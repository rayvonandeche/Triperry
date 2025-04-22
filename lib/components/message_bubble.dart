import 'package:flutter/material.dart';

enum MessageBubbleType { user, ai, system }

class MessageBubble extends StatelessWidget {
  final String message;
  final MessageBubbleType type;
  final Widget? avatar;
  final bool isAnimated;
  final VoidCallback? onTap;
  
  const MessageBubble({
    Key? key,
    required this.message,
    this.type = MessageBubbleType.ai,
    this.avatar,
    this.isAnimated = false,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final bool isUser = type == MessageBubbleType.user;
    final bool isSystem = type == MessageBubbleType.system;
    
    final bubbleColor = isUser 
        ? Theme.of(context).colorScheme.primaryContainer 
        : isSystem
            ? Theme.of(context).colorScheme.tertiaryContainer
            : Theme.of(context).colorScheme.secondaryContainer;
            
    final textColor = isUser 
        ? Theme.of(context).colorScheme.onPrimaryContainer 
        : isSystem
            ? Theme.of(context).colorScheme.onTertiaryContainer
            : Theme.of(context).colorScheme.onSecondaryContainer;
    
    final radius = const BorderRadius.all(Radius.circular(20));
    final userRadius = const BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(4),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    );
    final aiRadius = const BorderRadius.only(
      topLeft: Radius.circular(4),
      topRight: Radius.circular(20),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    );
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser && avatar != null) ...[
            avatar!,
            const SizedBox(width: 8.0),
          ],
          Flexible(
            child: Material(
              color: bubbleColor,
              borderRadius: isSystem ? radius : (isUser ? userRadius : aiRadius),
              elevation: 1,
              child: InkWell(
                onTap: onTap,
                borderRadius: isSystem ? radius : (isUser ? userRadius : aiRadius),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  child: Text(
                    message,
                    style: TextStyle(color: textColor),
                  ),
                ),
              ),
            ),
          ),
          if (isUser && avatar != null) ...[
            const SizedBox(width: 8.0),
            avatar!,
          ],
        ],
      ),
    );
  }
}