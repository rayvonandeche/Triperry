import 'dart:ui';
import 'package:triperry/providers/app_provider.dart';
import 'package:triperry/screens/ai/ai_screen.dart';
import 'package:triperry/screens/discover/discover_screen.dart';
import 'package:triperry/screens/trips/trips_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

// Import the modularized app bar actions
import 'package:triperry/features/app_bar_actions/app_bar_actions.dart';

part './drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _containerController;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;
  int _currentIndex = 0;
  bool showAI = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _containerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 400),
    )..reverse();

    _scaleAnimations = List.generate(4, (index) {
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

    _fadeAnimations = List.generate(4, (index) {
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

  @override
  Widget build(BuildContext context) {
    final double toolbarHeight =
        kToolbarHeight + MediaQuery.of(context).padding.top;

    SystemChrome.setSystemUIOverlayStyle(Theme.of(context).brightness ==
            Brightness.dark
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor:
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1))
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor:
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1)));

    // Use the modularized app bar actions
    final List<Widget> screenSpecificActions = getScreenSpecificActions(
      context,
      currentIndex: _currentIndex,
      showAI: showAI,
    );
            
    final Widget customToolbar = ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 28, sigmaY: 12),
        child: Container(
          height: toolbarHeight,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).scaffoldBackgroundColor.withOpacity(1),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
            ], stops: const [
              0.4,
              1.0,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                showAI ? 
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded), 
                    onPressed: _handleBack
                  ) : 
                  IconButton(
                    icon: const Icon(Icons.menu), 
                    onPressed: () => _scaffoldKey.currentState?.openDrawer()
                  ),
                Text(
                  'Triperry',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: screenSpecificActions,
                ),
              ],
            ),
          ),
        ),
      ),
    );

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
        body: Stack(children: [
          AnimatedSwitcher(
            switchInCurve: Curves.easeInOutQuad,
            switchOutCurve: Curves.easeInOutQuint,
            duration: const Duration(milliseconds: 400),
            child: showAI
                ? const AiPage() // Use AiPage from updated import
                : _currentIndex == 0
                    ? DiscoverPage( // Use DiscoverPage from updated import
                        toolbarHeight: toolbarHeight,
                        scaleAnimations: _scaleAnimations,
                        fadeAnimations: _fadeAnimations,
                        containerController: _containerController,
                      )
                    : const Trips(), // Use Trips from updated import
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: customToolbar,
          ),
        ]),
        bottomNavigationBar: showAI
            ? null
            : ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: BottomNavigationBar(
                      currentIndex: _currentIndex,
                      onTap: (value) => setState(() => _currentIndex = value),
                      backgroundColor: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.7),
                      items: const [
                        BottomNavigationBarItem(
                            label: 'Discover',
                            icon: Icon(Icons.auto_awesome_mosaic_sharp)),
                        BottomNavigationBarItem(
                            label: 'Trips',
                            icon: Icon(Icons.auto_stories_rounded)),
                      ]),
                ),
              ),
        floatingActionButton: !showAI
            ? FloatingActionButton(
                onPressed: _onButtonPressed,
                child: const Icon(Icons.auto_awesome),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        drawer: _buildDrawer(context: context,currentIndexx: _currentIndex, showAI: showAI, onButtonPressedd: _onButtonPressed, setState: setState),
      ),
    );
  }
}
