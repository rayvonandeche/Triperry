import 'dart:ui';
import 'package:triperry/screens/ai/ai_screen.dart';
import 'package:triperry/screens/buddies/buddies_screen.dart';
import 'package:triperry/screens/discover/discover_screen.dart';
import 'package:triperry/screens/profile/profile_screen.dart';
import 'package:triperry/screens/trips/trips_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:triperry/theme/app_theme.dart';

part './drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _containerController;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;
  bool showAI = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _containerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimations = List.generate(5, (index) {
      final double startInterval = index * 0.08;
      final double endInterval = startInterval + 0.4;
      return Tween<double>(begin: 1, end: 1.03).animate(
        CurvedAnimation(
          parent: _containerController,
          curve: Interval(
            startInterval,
            endInterval,
            curve: Curves.easeOutQuint,
          ),
          reverseCurve: Interval(
            startInterval,
            endInterval,
            curve: Curves.easeOutQuint,
          ),
        ),
      );
    });

    _fadeAnimations = List.generate(5, (index) {
      final double startInterval = index * 0.12;
      final double endInterval = math.min(startInterval + 0.3, 1.0);
      return Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _containerController,
          curve: Interval(
            startInterval,
            endInterval,
            curve: Curves.fastEaseInToSlowEaseOut,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _containerController.dispose();
    super.dispose();
  }

  Future<void> _onButtonPressed() async {
    if (!showAI) {
      _containerController.forward();
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() => showAI = true);
    } else {
      await _handleBack();
    }
  }

  Future<void> _handleBack() async {
    setState(() => showAI = false);
    await _containerController.reverse();
  }

  Widget _buildDiscoverPage() {
    return DiscoverPage(
      toolbarHeight: MediaQuery.of(context).padding.top + kToolbarHeight,
      scaleAnimations: _scaleAnimations,
      fadeAnimations: _fadeAnimations,
      containerController: _containerController,
    );
  }

  Widget _buildAppBar(BuildContext context, int currentIndex, bool showAI) {
    final double toolbarHeight =
        kToolbarHeight + MediaQuery.of(context).padding.top;
    final String title;
    final List<Widget> actions;

    if (showAI) {
      title = 'Triperry';
      actions = [
        IconButton(
          icon: const Icon(Icons.help_outline_rounded),
          onPressed: () {
            // Show help dialog
          },
        ),
      ];
    } else {
      switch (currentIndex) {
        case 0:
          title = 'Discover';
          actions = [
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () {
                // Show search
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list_rounded),
              onPressed: () {
                // Show filters
              },
            ),
          ];
          break;
        case 2:
          title = 'My Trips';
          actions = [
            IconButton(
              icon: const Icon(Icons.add_rounded),
              onPressed: () {
                // Add new trip
              },
            ),
          ];
          break;
        case 1:
          title = 'Buddies';
          actions = [
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () {
                // Search buddies
              },
            ),
          ];
          break;
        case 3:
          title = 'Profile';
          actions = [
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: () {
                // Open settings
              },
            ),
          ];
          break;
        default:
          title = 'Triperry';
          actions = [];
      }
    }

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 4),
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
                        onPressed: _handleBack,
                      )
                    : IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () =>
                            _scaffoldKey.currentState?.openDrawer(),
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
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(Theme.of(context).brightness ==
            Brightness.dark
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor:
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1))
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor:
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1)));

    return PopScope(
      canPop: !showAI,
      onPopInvokedWithResult: (didPop, _) async {
        if (showAI) {
          await _handleBack();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: Stack(
          children: [
            AnimatedSwitcher(
              switchInCurve: Curves.easeInOutQuad,
              switchOutCurve: Curves.easeInOutQuint,
              duration: const Duration(milliseconds: 400),
              child: showAI
                  ? const AiPage()
                  : _selectedIndex == 0
                      ? _buildDiscoverPage()
                      : _selectedIndex == 1
                          ? const BuddiesScreen()
                          : _selectedIndex == 2
                              ? const Trips()
                              : const ProfileScreen(),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildAppBar(context, _selectedIndex, showAI),
            ),
          ],
        ),
        bottomNavigationBar:
            showAI ? null : _buildBottomNavigationBar(context, _selectedIndex),
        floatingActionButton: !showAI
            ? FloatingActionButton(
                onPressed: _onButtonPressed,
                backgroundColor: AppTheme.primaryColor,
                child: const Icon(Icons.auto_awesome),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        drawer: _buildDrawer(
          context: context,
          currentIndexx: _selectedIndex,
          showAI: showAI,
          onButtonPressedd: _onButtonPressed,
          setState: setState,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, int currentIndex) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 4),
        child: Container(
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
              top: BorderSide(
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
                offset: const Offset(0, -2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: Theme.of(context).brightness == Brightness.dark
                ? AppTheme.lightText.withOpacity(0.6)
                : AppTheme.darkText.withOpacity(0.6),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_rounded),
                label: 'Discover',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group_rounded),
                label: 'Buddies',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.flight_rounded),
                label: 'My Trips',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
