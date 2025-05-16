import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_theme.dart';
import 'suggestion_chip.dart';

class AiWelcomeView extends StatelessWidget {
  final String userName;
  final void Function(String) onSuggestionTap;

  const AiWelcomeView({
    Key? key,
    required this.userName,
    required this.onSuggestionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildWelcomeTitle(),
          const SizedBox(height: 24),
          _buildSubtitle(context),
          const SizedBox(height: 40),
          _buildSuggestionChips(),
        ],
      ),
    );
  }

  Widget _buildWelcomeTitle() {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds);
      },
      child: Text(
        'Hello, $userName',
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(
          begin: -0.2,
          end: 0,
          duration: 600.ms,
          curve: Curves.easeOutQuart,
        );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      'Ask me anything about travel planning',
      style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
      ),
    ).animate(delay: 200.ms).fadeIn(duration: 600.ms);
  }

  Widget _buildSuggestionChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        SuggestionChip(
          text: "Safari recommendations",
          onTap: onSuggestionTap,
        ),
        SuggestionChip(
          text: "Best beaches in Kenya",
          onTap: onSuggestionTap,
        ),
        SuggestionChip(
          text: "Luxury hotels in Nairobi",
          onTap: onSuggestionTap,
        ),
        SuggestionChip(
          text: "Family-friendly activities",
          onTap: onSuggestionTap,
        ),
      ],
    ).animate(delay: 400.ms).fadeIn(duration: 800.ms);
  }
}