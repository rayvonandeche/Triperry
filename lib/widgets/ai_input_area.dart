import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:triperry/theme/app_theme.dart';

class AiInputArea extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onSubmitted;
  final List<String>? suggestions;
  final Function(String)? onSuggestionSelected;

  const AiInputArea({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSubmitted,
    this.suggestions,
    this.onSuggestionSelected,
  });

  @override
  State<AiInputArea> createState() => _AiInputAreaState();
}

class _AiInputAreaState extends State<AiInputArea> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Suggestions
            if (widget.suggestions != null && widget.suggestions!.isNotEmpty)
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.suggestions!.length,
                  itemBuilder: (context, index) {
                    final suggestion = widget.suggestions![index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ActionChip(
                        label: Text(suggestion),
                        onPressed: () {
                          if (widget.onSuggestionSelected != null) {
                            widget.onSuggestionSelected!(suggestion);
                          }
                        },
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Input field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: _isFocused
                            ? AppTheme.primaryColor.withOpacity(0.05)
                            : Colors.grey.withOpacity(0.1),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: _isFocused
                              ? AppTheme.primaryColor
                              : Colors.grey,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                      onSubmitted: widget.onSubmitted,
                      onTap: () {
                        setState(() {
                          _isFocused = true;
                        });
                      },
                      onEditingComplete: () {
                        setState(() {
                          _isFocused = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (widget.controller.text.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        widget.controller.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear),
                      color: Colors.grey,
                    ),
                  IconButton(
                    onPressed: () {
                      if (widget.controller.text.isNotEmpty) {
                        widget.onSubmitted(widget.controller.text);
                        widget.controller.clear();
                        setState(() {});
                      }
                    },
                    icon: Icon(
                      Icons.send,
                      color: widget.controller.text.isNotEmpty
                          ? AppTheme.primaryColor
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 