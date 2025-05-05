import 'package:flutter/material.dart';

/// Helper class to create animations for the AI screen
class AiAnimations {
  /// Create a slide animation for the header
  static Animation<Offset> createHeaderSlideAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    ));
  }
  
  /// Create a fade animation
  static Animation<double> createFadeAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutQuart,
    ));
  }
  
  /// Create a vertical slide animation
  static Animation<Offset> createVerticalSlideAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    ));
  }
  
  /// Create a horizontal slide animation
  static Animation<Offset> createHorizontalSlideAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0.1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    ));
  }
  
  /// Create a scale animation
  static Animation<double> createScaleAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    ));
  }
  
  /// Create staggered animations
  static List<Animation<double>> createStaggeredFadeAnimations(
    AnimationController controller, 
    int count,
  ) {
    return List.generate(count, (index) {
      final startInterval = index * 0.1;
      final endInterval = startInterval + 0.4;
      
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(
          startInterval,
          endInterval,
          curve: Curves.easeOutQuart,
        ),
      ));
    });
  }
  
  /// Create pulse animation for selection
  static Animation<double> createPulseAnimation(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.05)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(controller);
  }
}