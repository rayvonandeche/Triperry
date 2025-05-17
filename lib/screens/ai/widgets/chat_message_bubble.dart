import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_theme.dart';
import '../models/chat_message.dart';
import 'attachment_content.dart';
import 'package:flutter/services.dart';

class ChatMessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime time;
  final List<MessageAttachment>? attachments;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.time,
    this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (!isUser) {
      // AI message: parse and render rich content
      return Padding(
        padding: const EdgeInsets.only(bottom: 24, left: 0, right: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 0, top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (attachments != null && attachments!.isNotEmpty)
                    _buildAttachments(attachments!),
                  if (message.trim().isNotEmpty)
                    _buildRichAIContent(context, message, isDarkMode),
                ],
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.2, end: 0, duration: 300.ms);
    }
    // User message
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
        right: 0,
        left: 60,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.primaryColor.withOpacity(0.2)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 3,
                    spreadRadius: 0.5,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (attachments != null && attachments!.isNotEmpty)
                    _buildAttachments(attachments!),
                  if (message.trim().isNotEmpty)
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.2, end: 0, duration: 300.ms);
  }

  // Avatar builder removed as we no longer show AI icon
  Widget _buildAttachments(List<MessageAttachment> attachments) {
    // Use the reusable AttachmentContent widget
    return AttachmentContent(attachments: attachments);
  }

  // Parses Gemini/AI markdown-like output and builds rich widgets
  Widget _buildRichAIContent(
      BuildContext context, String text, bool isDarkMode) {
    final List<Widget> children = [];
    final lines = text.split('\n');
    List<String> imageUrls = [];
    bool inList = false;
    bool isNumberedList = false;
    int listItemNumber = 1;
    List<Widget> currentList = [];
    bool inCodeBlock = false;
    StringBuffer codeBuffer = StringBuffer();
    String? codeLanguage;
    bool inTable = false;
    List<List<String>> tableData = [];
    List<String> tableHeader = [];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trim();

      // Code block detection
      if (trimmed.startsWith('```')) {
        if (!inCodeBlock) {
          // Starting a code block
          inCodeBlock = true;
          codeLanguage =
              trimmed.length > 3 ? trimmed.substring(3).trim() : null;
          continue;
        } else {
          // Ending a code block
          inCodeBlock = false;
          final code = codeBuffer.toString();
          children
              .add(_buildCodeBlock(context, code, codeLanguage, isDarkMode));
          codeBuffer = StringBuffer();
          codeLanguage = null;
          continue;
        }
      }

      // Inside a code block, just add lines to buffer
      if (inCodeBlock) {
        if (codeBuffer.isNotEmpty) {
          codeBuffer.write('\n');
        }
        codeBuffer.write(line);
        continue;
      }

      // Table detection
      if (trimmed.startsWith('|') && trimmed.endsWith('|')) {
        final cells = trimmed
            .split('|')
            .where((cell) => cell.isNotEmpty)
            .map((cell) => cell.trim())
            .toList();

        // Check if this is a table header or divider
        if (!inTable) {
          inTable = true;
          tableHeader = cells;
          // Skip the divider line that might follow the header
          if (i + 1 < lines.length &&
              lines[i + 1].trim().startsWith('|') &&
              lines[i + 1].trim().contains('-')) {
            i++; // Skip the divider line
          }
        } else {
          tableData.add(cells);
        }

        // Check if we're at the end of the table (next line doesn't start with |)
        if (i + 1 >= lines.length || !lines[i + 1].trim().startsWith('|')) {
          children
              .add(_buildTable(context, tableHeader, tableData, isDarkMode));
          inTable = false;
          tableHeader = [];
          tableData = [];
        }
        continue;
      }

      // Image detection (simple: http/https and ends with image extension)
      final imageRegex = RegExp(r'(https?:[^\s]+\.(?:png|jpg|jpeg|gif|webp))',
          caseSensitive: false);
      final match = imageRegex.firstMatch(trimmed);
      if (match != null) {
        imageUrls.add(match.group(1)!);
        continue;
      }

      // Handle heading levels (up to h5)
      if (trimmed.startsWith('# ')) {
        if (inList && currentList.isNotEmpty) {
          children.add(_buildListWidget(currentList, isNumberedList));
          currentList = [];
          inList = false;
          isNumberedList = false;
          listItemNumber = 1;
        }

        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              trimmed.substring(2),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: isDarkMode ? AppTheme.primaryColor : AppTheme.primaryColor,
              ),
            ),
          ),
        );
        continue;
      }

      if (trimmed.startsWith('## ')) {
        if (inList && currentList.isNotEmpty) {
          children.add(_buildListWidget(currentList, isNumberedList));
          currentList = [];
          inList = false;
          isNumberedList = false;
          listItemNumber = 1;
        }

        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 6),
            child: Text(
              trimmed.substring(3),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: isDarkMode
                    ? AppTheme.secondaryColor
                    : AppTheme.primaryColor.withOpacity(0.9),
              ),
            ),
          ),
        );
        continue;
      }

      if (trimmed.startsWith('### ')) {
        if (inList && currentList.isNotEmpty) {
          children.add(_buildListWidget(currentList, isNumberedList));
          currentList = [];
          inList = false;
          isNumberedList = false;
          listItemNumber = 1;
        }

        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(
              trimmed.substring(4),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
        continue;
      }

      // Handle bullet lists
      if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
        if (inList && isNumberedList) {
          // If we were in a numbered list, end it and start a bullet list
          children.add(_buildListWidget(currentList, true));
          currentList = [];
          listItemNumber = 1;
        }

        inList = true;
        isNumberedList = false;
        currentList.add(
            _buildListItemContent(context, trimmed.substring(2), isDarkMode));
        continue;
      }

      // Handle numbered lists
      final numberedListMatch = RegExp(r'^(\d+)\.').firstMatch(trimmed);
      if (numberedListMatch != null) {
        if (inList && !isNumberedList) {
          // If we were in a bullet list, end it and start a numbered list
          children.add(_buildListWidget(currentList, false));
          currentList = [];
        }

        inList = true;
        isNumberedList = true;
        final listText = trimmed.substring(numberedListMatch.end).trim();
        listItemNumber = int.parse(numberedListMatch.group(1)!);
        currentList.add(_buildListItemContent(context, listText, isDarkMode,
            number: listItemNumber));
        listItemNumber++; // Increment for next item
        continue;
      }

      // Close list if we have an empty line or non-list content
      if (inList &&
          (trimmed.isEmpty ||
              (!trimmed.startsWith('- ') &&
                  !trimmed.startsWith('* ') &&
                  numberedListMatch == null))) {
        // Only end list if it's not just a blank line in the middle of list items
        bool isEmptyLineBetweenListItems = trimmed.isEmpty &&
            i + 1 < lines.length &&
            (lines[i + 1].trim().startsWith('- ') ||
                lines[i + 1].trim().startsWith('* ') ||
                RegExp(r'^(\d+)\.').hasMatch(lines[i + 1].trim()));

        if (!isEmptyLineBetweenListItems) {
          children.add(_buildListWidget(currentList, isNumberedList));
          currentList = [];
          inList = false;
          isNumberedList = false;
          listItemNumber = 1;
        }
      }

      // Handle normal paragraph text with inline formatting
      if (trimmed.isNotEmpty && !inList) {
        children.add(_buildFormattedText(context, trimmed, isDarkMode));
        continue;
      }

      // Add paragraph spacing for empty lines (if not in a list)
      if (trimmed.isEmpty && !inList && i > 0 && i < lines.length - 1) {
        if (lines[i - 1].trim().isNotEmpty && lines[i + 1].trim().isNotEmpty) {
          children.add(const SizedBox(height: 8));
        }
      }
    }

    // Add any remaining list
    if (inList && currentList.isNotEmpty) {
      children.add(_buildListWidget(currentList, isNumberedList));
    }

    // Add remaining code block if any
    if (inCodeBlock && codeBuffer.isNotEmpty) {
      children.add(_buildCodeBlock(
          context, codeBuffer.toString(), codeLanguage, isDarkMode));
    }

    // Add image carousel if images found
    if (imageUrls.isNotEmpty) {
      children.add(const SizedBox(height: 12));
      children.add(_buildImageCarousel(imageUrls));
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  // Build formatted text with support for **bold**, *italic*, and `code` inline styles
  Widget _buildFormattedText(
      BuildContext context, String text, bool isDarkMode) {
    // Handle bold, italic, code, and links with regular expressions
    final textSpans = <TextSpan>[];
    final defaultStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: isDarkMode ? Colors.white : Colors.black87,
      fontSize: 15,
    );

    // Split by inline code first
    final parts = text.split('`');
    for (var i = 0; i < parts.length; i++) {
      // Every odd index is inside code blocks
      if (i % 2 == 1) {
        textSpans.add(TextSpan(
          text: parts[i],
          style: TextStyle(
            fontFamily: 'monospace',
            backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
            color: isDarkMode ? Colors.lightBlueAccent : Colors.blueAccent,
            fontSize: 14,
          ),
        ));
      } else {
        // Handle bold and italic in non-code blocks
        String current = parts[i];

        // Bold
        final boldParts = current.split('**');
        if (boldParts.length > 1) {
          for (var j = 0; j < boldParts.length; j++) {
            if (boldParts[j].isEmpty) continue;

            if (j % 2 == 1) {
              // Bold text
              textSpans.add(TextSpan(
                text: boldParts[j],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ));
            } else {
              // Handle italic in non-bold text
              final italicParts = boldParts[j].split('*');
              _processItalicParts(italicParts, textSpans);
            }
          }
        } else {
          // Handle italic when no bold is present
          final italicParts = current.split('*');
          _processItalicParts(italicParts, textSpans);
        }
      }
    }

    return RichText(
      text: TextSpan(
        children: textSpans,
        style: defaultStyle,
      ),
    );
  }

  // Process italic parts of text
  void _processItalicParts(List<String> italicParts, List<TextSpan> textSpans) {
    for (var k = 0; k < italicParts.length; k++) {
      if (italicParts[k].isEmpty) continue;

      if (k % 2 == 1) {
        // Italic text
        textSpans.add(TextSpan(
          text: italicParts[k],
          style: const TextStyle(fontStyle: FontStyle.italic),
        ));
      } else {
        // Regular text
        textSpans.add(TextSpan(text: italicParts[k]));
      }
    }
  }

  Widget _buildListWidget(List<Widget> items, bool isNumbered) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }

  Widget _buildListItemContent(
      BuildContext context, String text, bool isDarkMode,
      {int? number}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Text(
              number != null ? '$number.' : '•',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppTheme.primaryColor : AppTheme.primaryColor,
              ),
            ),
          ),
          Expanded(child: _buildFormattedText(context, text, isDarkMode)),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(List<String> urls) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, idx) {
          final url = urls[idx];
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 240,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image,
                            size: 48, color: Colors.grey),
                      ),
                    ),
                    loadingBuilder: (ctx, child, progress) {
                      if (progress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                  (progress.expectedTotalBytes ?? 1)
                              : null,
                          color: AppTheme.primaryColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Image counter badge on bottom right
              if (urls.length > 1)
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${idx + 1}/${urls.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCodeBlock(
      BuildContext context, String code, String? language, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Code header with language label and copy button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(7)),
            ),
            child: Row(
              children: [
                if (language != null && language.isNotEmpty)
                  Text(
                    language,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, size: 16),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  tooltip: 'Copy to clipboard',
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Code copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Code content
          Padding(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              code,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                fontSize: 13,
                color: isDarkMode ? Colors.grey[300] : Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<String> headers,
      List<List<String>> rows, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            border: TableBorder(
              horizontalInside: BorderSide(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1,
              ),
              verticalInside: BorderSide(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1,
              ),
            ),
            defaultColumnWidth: const IntrinsicColumnWidth(),
            children: [
              // Header row
              TableRow(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                ),
                children: headers
                    .map((header) =>
                        _buildTableCell(header, isDarkMode, isHeader: true, context: context))
                    .toList(),
              ),
              // Data rows
              ...rows.map((row) => TableRow(
                    children: row
                        .map((cell) => _buildTableCell(cell, isDarkMode, context: context))
                        .toList(),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, bool isDarkMode,
      {bool isHeader = false, BuildContext? context}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      alignment: isHeader ? Alignment.center : Alignment.centerLeft,
      child: _buildFormattedTableText(text, isDarkMode, isHeader, context!),
    );
  }

  Widget _buildFormattedTableText(String text, bool isDarkMode, bool isHeader, BuildContext context) {
    final textSpans = <TextSpan>[];
    final baseStyle = isHeader
        ? Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 14,
          )
        : Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDarkMode ? Colors.grey[300] : Colors.black87,
            fontSize: 13,
          );

    // Split by inline code first
    final parts = text.split('`');
    for (var i = 0; i < parts.length; i++) {
      // Every odd index is inside code blocks
      if (i % 2 == 1) {
        textSpans.add(TextSpan(
          text: parts[i],
          style: TextStyle(
            fontFamily: 'monospace',
            backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
            color: isDarkMode ? Colors.lightBlueAccent : Colors.blueAccent,
            fontSize: isHeader ? 14 : 13,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          ),
        ));
      } else {
        // Handle bold and italic in non-code blocks
        String current = parts[i];

        // Bold
        final boldParts = current.split('**');
        if (boldParts.length > 1) {
          for (var j = 0; j < boldParts.length; j++) {
            if (boldParts[j].isEmpty) continue;

            if (j % 2 == 1) {
              // Bold text
              textSpans.add(TextSpan(
                text: boldParts[j],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isHeader ? 14 : 13,
                  color: isDarkMode
                      ? (isHeader ? Colors.white : Colors.grey[300])
                      : (isHeader ? Colors.black : Colors.black87),
                ),
              ));
            } else {
              // Handle italic in non-bold text
              final italicParts = boldParts[j].split('*');
              _processTableItalicParts(
                  italicParts, textSpans, isDarkMode, isHeader);
            }
          }
        } else {
          // Handle italic when no bold is present
          final italicParts = current.split('*');
          _processTableItalicParts(
              italicParts, textSpans, isDarkMode, isHeader);
        }
      }
    }

    return RichText(
      text: TextSpan(
        children: textSpans,
        style: baseStyle,
      ),
    );
  }

  // Process italic parts of text within table cells
  void _processTableItalicParts(List<String> italicParts,
      List<TextSpan> textSpans, bool isDarkMode, bool isHeader) {
    for (var k = 0; k < italicParts.length; k++) {
      if (italicParts[k].isEmpty) continue;

      if (k % 2 == 1) {
        // Italic text
        textSpans.add(TextSpan(
          text: italicParts[k],
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: isHeader ? 14 : 13,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            color: isDarkMode
                ? (isHeader ? Colors.white : Colors.grey[300])
                : (isHeader ? Colors.black : Colors.black87),
          ),
        ));
      } else {
        // Regular text
        textSpans.add(TextSpan(
          text: italicParts[k],
          style: TextStyle(
            fontSize: isHeader ? 14 : 13,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            color: isDarkMode
                ? (isHeader ? Colors.white : Colors.grey[300])
                : (isHeader ? Colors.black : Colors.black87),
          ),
        ));
      }
    }
  }
}
