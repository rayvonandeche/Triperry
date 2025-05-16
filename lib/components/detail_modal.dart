import 'package:flutter/material.dart';
import 'dart:ui';

/// A helper class to show a beautiful modal with content without navigating
class DetailModal {
  /// Shows a modal bottom sheet with the provided content
  /// 
  /// - [context]: BuildContext
  /// - [title]: Optional title for the modal
  /// - [content]: Widget to display in the modal body
  /// - [fullScreen]: Whether the modal should take full screen height
  /// - [enableDrag]: Whether the modal can be dragged
  /// - [actions]: Optional list of action buttons to show at the bottom
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    bool fullScreen = false,
    bool enableDrag = true,
    List<Widget>? actions,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => _DetailModalContent(
        title: title,
        content: content,
        fullScreen: fullScreen,
        actions: actions,
      ),
    );
  }
}

class _DetailModalContent extends StatelessWidget {
  final String? title;
  final Widget content;
  final bool fullScreen;
  final List<Widget>? actions;

  const _DetailModalContent({
    required this.content,
    this.title,
    this.fullScreen = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    
    return Container(
      margin: EdgeInsets.only(top: fullScreen ? 40 : 80),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.white.withOpacity(0.1) 
                : Colors.black.withOpacity(0.05),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle indicator
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              // Title if provided
              if (title != null) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title!,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
                Divider(),
              ],

              // Content with scroll if needed
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, actions != null ? 0 : 16 + bottomPadding),
                  child: content,
                ),
              ),

              // Action buttons if provided
              if (actions != null) ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions!,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
