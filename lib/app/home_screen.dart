import 'dart:ui';
import 'package:triperry/screens/ai/ai_screen_modular.dart';
import 'package:triperry/screens/buddies/buddies_screen.dart';
import 'package:triperry/screens/discover/discover_screen.dart';
import 'package:triperry/screens/profile/profile_screen.dart';
import 'package:triperry/screens/trips/trips_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:triperry/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:triperry/services/auth_service.dart';
import 'package:triperry/widgets/triperry_app_bar.dart';
// Removed unused import
import 'package:triperry/features/app_bar_actions/ai/mini_assistant_service.dart';
import 'package:triperry/screens/ai/models/chat_message.dart';

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
  bool _showMiniAssistant = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Mini AI assistant service
  final MiniAssistantService _miniAssistantService = MiniAssistantService();

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Skip auth check if coming from AI screen
    final route = ModalRoute.of(context)?.settings.name;
    if (route != '/ai') {
      // Check if user is logged in
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final authService = Provider.of<AuthService>(context, listen: false);
        if (!authService.isLoggedIn) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      });
    }
  }
  @override
  void dispose() {
    _containerController.dispose();
    _miniAssistantService.dispose();
    super.dispose();
  }  Future<void> _onButtonPressed() async {
    // Toggle between showing mini-assistant or full AI screen
    if (!showAI && !_showMiniAssistant) {
      setState(() => _showMiniAssistant = true);
    } else if (_showMiniAssistant) {
      setState(() => _showMiniAssistant = false);
    } else {
      await _handleBack();
    }
  }
    void _handleMiniAssistantSubmit(String text) {
    if (text.isEmpty) return;
    
    // If assistant is not showing, show it with a nice animation
    if (!_showMiniAssistant) {
      setState(() => _showMiniAssistant = true);
    }
    
    // Add a small delay for better UX
    Future.delayed(const Duration(milliseconds: 50), () {
      _miniAssistantService.addUserMessage(text);
    });
  }
  
  void _expandToFullAi() async {
    setState(() => _showMiniAssistant = false);
    
    // Small delay to allow the mini assistant to close
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Open the full AI screen
    _containerController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => showAI = true);
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
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.filter_list_rounded),
              onPressed: () {},
            ),
          ];
          break;
        case 2:
          title = 'My Trips';
          actions = [
            IconButton(
              icon: const Icon(Icons.add_rounded),
              onPressed: () {},
            ),
          ];
          break;
        case 1:
          title = 'Buddies';
          actions = [
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () {},
            ),
          ];
          break;
        case 3:
          title = 'Profile';
          actions = [
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: () {},
            ),
          ];
          break;
        default:
          title = 'Triperry';
          actions = [];
      }
    }
    return TriperryAppBar(
      title: title,
      actions: actions,
      showAI: showAI,
      showMiniInput: _showMiniAssistant && !showAI,
      onBack: _handleBack,
      onMenu: () => _scaffoldKey.currentState?.openDrawer(),
      onMiniInputSubmit: _handleMiniAssistantSubmit,
      onMiniInputCancel: () => setState(() => _showMiniAssistant = false),
      onMiniInputExpand: _expandToFullAi,
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
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1)));    return PopScope(
      canPop: !showAI && !_showMiniAssistant,
      onPopInvokedWithResult: (didPop, _) async {
        if (showAI) {
          await _handleBack();
        } else if (_showMiniAssistant) {
          setState(() => _showMiniAssistant = false);
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
                  ? const AiPageModular()
                  : _selectedIndex == 0
                      ? _buildDiscoverPage()
                      : _selectedIndex == 1
                          ? const BuddiesScreen()
                          : _selectedIndex == 2
                              ? const Trips()
                              : const ProfileScreen(),
            ),            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildAppBar(context, _selectedIndex, showAI),
            ),              // Mini AI Assistant Response
            if (_showMiniAssistant && !showAI)
              Positioned(
                top: kToolbarHeight + MediaQuery.of(context).padding.top + 5,
                left: 0,
                right: 0,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -0.2),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: StreamBuilder<bool>(
                    key: ValueKey('mini_assistant_response'),
                    stream: _miniAssistantService.isTypingStream,
                    initialData: _miniAssistantService.isTyping,
                    builder: (context, typingSnapshot) {
                      final isTyping = typingSnapshot.data ?? false;
                      final lastResponse = _miniAssistantService.lastResponse;
                      
                      if (lastResponse == null && !isTyping) return const SizedBox.shrink();
                      
                      return _buildMiniAssistantResponse(isTyping, lastResponse);
                    },
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar:
            showAI ? null : _buildBottomNavigationBar(context, _selectedIndex),        floatingActionButton: !showAI
            ? FloatingActionButton(
                onPressed: _onButtonPressed,
                backgroundColor: _showMiniAssistant 
                  ? AppTheme.secondaryColor
                  : AppTheme.primaryColor,
                tooltip: _showMiniAssistant ? 'Close Assistant' : 'AI Assistant',
                elevation: 4,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: _showMiniAssistant
                      ? const Icon(
                          Icons.close_rounded,
                          key: ValueKey('close'),
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.auto_awesome,
                          key: ValueKey('assistant'),
                          color: Colors.white,
                        ),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        drawer: _buildDrawer(
          context: context,
          currentIndex: _selectedIndex,
          showAI: showAI,
          onButtonPressed: _onButtonPressed,
          setState: setState,
        ),
      ),
    );
  }  Widget _buildMiniAssistantResponse(bool isTyping, ChatMessage? lastResponse) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode 
        ? Colors.grey[850]!.withOpacity(0.95)
        : Colors.white.withOpacity(0.95);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
          width: 0.8,
        ),
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
                  Colors.grey[850]!.withOpacity(0.95),
                  Colors.grey[900]!.withOpacity(0.9),
                ]
              : [
                  Colors.white.withOpacity(0.95),
                  Colors.grey[50]!.withOpacity(0.9),
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              Text(
                'Triperry AI',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: _expandToFullAi,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.open_in_full,
                    size: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => setState(() => _showMiniAssistant = false),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          isTyping
              ? _buildTypingIndicator()
              : lastResponse != null
                  ? Text(
                      lastResponse.text,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    )
                  : const SizedBox.shrink(),
        ],
      ),
    );
  }
  
  Widget _buildTypingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Thinking...',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
      ],
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
                icon: Icon(Icons.auto_awesome_mosaic),
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

  Widget _buildDrawer(
      {required BuildContext context,
      required int currentIndex,
      required bool showAI,
      required Function() onButtonPressed,
      required void Function(void Function()) setState}) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    final String userInitial = user?.name != null && user!.name.isNotEmpty
        ? user.name.substring(0, 1)
        : 'G';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            accountName: Text(
              user?.name ?? 'Guest User',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                userInitial,
                style: const TextStyle(
                  fontSize: 24,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.explore_rounded),
            title: const Text('Discover'),
            selected: currentIndex == 0 && !showAI,
            onTap: () {
              setState(() => _selectedIndex = 0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.group_rounded),
            title: const Text('Buddies'),
            selected: currentIndex == 1 && !showAI,
            onTap: () {
              setState(() => _selectedIndex = 1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.flight_rounded),
            title: const Text('My Trips'),
            selected: currentIndex == 2 && !showAI,
            onTap: () {
              setState(() => _selectedIndex = 2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_rounded),
            title: const Text('Profile'),
            selected: currentIndex == 3 && !showAI,
            onTap: () {
              setState(() => _selectedIndex = 3);
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.auto_awesome),
            title: const Text('AI Assistant'),
            selected: showAI,
            onTap: () {
              onButtonPressed();
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to help
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await authService.logout();
              if (!context.mounted) return;
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}
