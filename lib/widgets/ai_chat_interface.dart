import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:triperry/theme/app_theme.dart';

class AiChatInterface extends StatelessWidget {
  final String message;
  final bool isUser;
  final List<Widget>? suggestions;
  final Widget? additionalContent;
  final Animation<double>? animation;

  const AiChatInterface({
    super.key,
    required this.message,
    this.isUser = false,
    this.suggestions,
    this.additionalContent,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Message bubble
          GlassmorphicContainer(
            width: double.infinity,
            height: 100,
            borderRadius: 16,
            blur: 10,
            alignment: Alignment.center,
            border: 1,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                isUser
                    ? AppTheme.primaryColor.withOpacity(0.1)
                    : Colors.white.withOpacity(0.1),
                isUser
                    ? AppTheme.primaryColor.withOpacity(0.05)
                    : Colors.white.withOpacity(0.05),
              ],
            ),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                isUser
                    ? AppTheme.primaryColor.withOpacity(0.2)
                    : Colors.white.withOpacity(0.2),
                isUser
                    ? AppTheme.primaryColor.withOpacity(0.1)
                    : Colors.white.withOpacity(0.1),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isUser ? AppTheme.primaryColor : Colors.black87,
                        ),
                  ),
                  if (additionalContent != null) ...[
                    const SizedBox(height: 16),
                    additionalContent!,
                  ],
                ],
              ),
            ),
          ).animate(
            effects: [
              FadeEffect(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
              ),
              SlideEffect(
                begin: Offset(isUser ? 0.2 : -0.2, 0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
              ),
            ],
          ),

          // Suggestions
          if (suggestions != null && suggestions!.isNotEmpty) ...[
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: suggestions!
                    .map((suggestion) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: suggestion,
                        ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SuggestionChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;

  const SuggestionChip({
    super.key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.white.withOpacity(0.2),
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? AppTheme.primaryColor : Colors.white,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
        ),
      ),
    );
  }
}

class TravelOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;

  const TravelOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 