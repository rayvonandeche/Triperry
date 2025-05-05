import 'package:flutter/material.dart';

/// Widget that displays the input area at the bottom of the screen
class InputArea extends StatelessWidget {
  /// Controller for the text field
  final TextEditingController textController;
  
  /// Input hint text to display
  final String inputHint;
  
  /// Callback when user submits input
  final Function(String) onSubmit;
  
  /// Optional suggestions to display as chips
  final List<String>? suggestions;

  const InputArea({
    super.key,
    required this.textController,
    required this.inputHint,
    required this.onSubmit,
    this.suggestions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Suggestion chips
          if (suggestions != null && suggestions!.isNotEmpty)
            Container(
              height: 50,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: suggestions!.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions![index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ActionChip(
                      label: Text(suggestion),
                      onPressed: () => onSubmit(suggestion),
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),

          // Input field
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: TextField(
                      controller: textController,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: inputHint,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      onSubmitted: onSubmit,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_upward_rounded, color: Colors.white),
                    onPressed: () => onSubmit(textController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}