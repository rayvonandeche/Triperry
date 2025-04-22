import 'package:flutter/material.dart';

class AnimatedResponseLine extends StatefulWidget {
  final String text;
  final Duration duration;
  final TextStyle? style;
  
  const AnimatedResponseLine({
    Key? key,
    required this.text,
    this.duration = const Duration(milliseconds: 1500),
    this.style,
  }) : super(key: key);

  @override
  State<AnimatedResponseLine> createState() => _AnimatedResponseLineState();
}

class _AnimatedResponseLineState extends State<AnimatedResponseLine> 
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  String _displayText = "";
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    
    _controller.addListener(_updateText);
    _controller.forward();
  }
  
  void _updateText() {
    final progress = _animation.value;
    final charCount = (widget.text.length * progress).floor();
    
    if (charCount > 0) {
      setState(() {
        _displayText = widget.text.substring(0, charCount);
      });
    }
  }
  
  @override
  void dispose() {
    _controller.removeListener(_updateText);
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            _displayText,
            style: widget.style ?? Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        if (_animation.value < 1.0)
          SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
      ],
    );
  }
}