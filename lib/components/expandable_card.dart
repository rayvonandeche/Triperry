import 'package:flutter/material.dart';

/// A card widget that can expand to show more details when tapped
class ExpandableCard extends StatefulWidget {
  /// The title of the card
  final String title;
  
  /// Optional subtitle shown below the title 
  final String? subtitle;
  
  /// Optional leading widget (typically an icon or avatar)
  final Widget? leading;
  
  /// Optional trailing widget shown on the right when collapsed
  final Widget? trailing;
  
  /// Content to show when the card is expanded
  final Widget expandedContent;
  
  /// Background color for the card
  final Color? backgroundColor;
  
  /// Border radius for the card
  final double borderRadius;
  
  /// Whether the card should start expanded
  final bool initiallyExpanded;
  
  /// Optional callback when card expands/collapses
  final ValueChanged<bool>? onExpansionChanged;

  const ExpandableCard({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required this.expandedContent,
    this.backgroundColor,
    this.borderRadius = 12.0,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
  }) : super(key: key);

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: _isExpanded ? 1.0 : 0.0,
    );
    
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      
      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged!(_isExpanded);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: widget.backgroundColor ?? theme.cardColor,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header section (always visible)
          InkWell(
            onTap: _toggleExpanded,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  if (widget.leading != null) ...[
                    widget.leading!,
                    const SizedBox(width: 16.0),
                  ],
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 4.0),
                          Text(
                            widget.subtitle!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  widget.trailing ?? RotationTransition(
                    turns: _rotationAnimation,
                    child: Icon(
                      Icons.expand_more,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Animated expanded content
          ClipRect(
            child: AnimatedBuilder(
              animation: _expandAnimation,
              builder: (context, child) {
                return Align(
                  heightFactor: _expandAnimation.value,
                  child: child,
                );
              },
              child: Column(
                children: [
                  if (!widget.initiallyExpanded) Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: widget.expandedContent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
