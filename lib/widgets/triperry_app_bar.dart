import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TriperryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final bool showAI;
  final VoidCallback? onBack;
  final VoidCallback? onMenu;

  const TriperryAppBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.showAI = false,
    this.onBack,
    this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    final double toolbarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 2),
        child: Container(
          height: toolbarHeight,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkSurface.withOpacity(0.97)
                    : AppTheme.lightSurface.withOpacity(0.97),
                Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkSurface.withOpacity(0.85)
                    : AppTheme.lightSurface.withOpacity(0.85),
              ],
              stops: const [0.3, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.black.withOpacity(0.03),
                width: 0.8,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                showAI
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: onBack,
                      )
                    : IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: onMenu,
                      ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppTheme.lightText
                            : AppTheme.darkText,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
