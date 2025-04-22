import 'package:flutter/material.dart';

class FollowUpInput extends StatefulWidget {
  final Function(String) onSubmitted;
  final List<String> suggestions;
  
  const FollowUpInput({
    Key? key,
    required this.onSubmitted,
    this.suggestions = const [],
  }) : super(key: key);

  @override
  State<FollowUpInput> createState() => _FollowUpInputState();
}

class _FollowUpInputState extends State<FollowUpInput> {
  final TextEditingController _controller = TextEditingController();
  bool _showSuggestions = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmitted(text);
      _controller.clear();
      setState(() {
        _showSuggestions = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Suggestion chips
        if (_showSuggestions && widget.suggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.suggestions.map((suggestion) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ActionChip(
                      label: Text(suggestion),
                      onPressed: () {
                        setState(() {
                          _showSuggestions = false;
                        });
                        widget.onSubmitted(suggestion);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
        // Input field
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Ask a follow-up question...",
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _handleSubmit(),
                  onChanged: (_) {
                    if (!_showSuggestions) {
                      setState(() {
                        _showSuggestions = true;
                      });
                    }
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.send_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ],
    );
  }
}