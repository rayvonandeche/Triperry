import 'package:flutter/material.dart';

/// Utility class for creating animations used in the AI conversation screen
class AiAnimations {
  /// Creates a slide animation from the top
  static Animation<Offset> createHeaderSlideAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutQuart,
    ));
  }

  /// Creates a fade animation
  static Animation<double> createFadeAnimation(AnimationController controller) {
    return controller;
  }

  /// Creates a slide animation from the side
  static Animation<Offset> createHorizontalSlideAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutQuint,
    ));
  }

  /// Creates a slide animation from the bottom
  static Animation<Offset> createVerticalSlideAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutQuint,
    ));
  }

  /// Creates a tip slide animation with delay
  static Animation<Offset> createTipSlideAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOutQuad),
    ));
  }
}