import 'package:flutter/material.dart';
import 'package:triperry/theme/app_theme.dart';

class TriperryMiniInput extends StatefulWidget {
  final Function(String) onSubmitted;
  final VoidCallback onCancel;
  final VoidCallback onExpand;
  
  const TriperryMiniInput({
    Key? key,
    required this.onSubmitted,
    required this.onCancel,
    required this.onExpand,
  }) : super(key: key);

  @override
  State<TriperryMiniInput> createState() => _TriperryMiniInputState();
}

class _TriperryMiniInputState extends State<TriperryMiniInput> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    widget.onSubmitted(text);
    _controller.clear();
  }
  
  Future<void> _handleCancel() async {
    await _animationController.reverse();
    widget.onCancel();
  }
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode 
        ? Colors.grey[850]
        : Colors.white;
        
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * _animation.value),
          child: Container(
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
                width: 0.8,
              ),
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [
                        Colors.grey[800]!,
                        Colors.grey[850]!,
                      ]
                    : [
                        Colors.white,
                        Colors.grey[50]!,
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.5)
                            : Colors.black.withOpacity(0.5),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    style: const TextStyle(fontSize: 14),
                    onSubmitted: (_) => _handleSubmit(),
                    autofocus: true,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_full, size: 18),
                  onPressed: widget.onExpand,
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                  splashRadius: 18,
                  tooltip: 'Open full assistant',
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: _handleCancel,
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                  splashRadius: 18,
                  tooltip: 'Close',
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
