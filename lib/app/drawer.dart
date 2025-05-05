part of './home_screen.dart';

Widget _buildDrawer({
  required BuildContext context,
  required int currentIndexx,
  required bool showAI,
  required VoidCallback onButtonPressedd,
  required void Function(void Function()) setState,
}) {
  final UserAccountsDrawerHeader drawerHeader = UserAccountsDrawerHeader(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.primaryColor.withOpacity(0.95),
          AppTheme.primaryColor.withBlue(AppTheme.primaryColor.blue + 20).withOpacity(0.85),
          AppTheme.primaryColor.withRed(AppTheme.primaryColor.red + 15).withOpacity(0.8),
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
      boxShadow: [
        BoxShadow(
          color: AppTheme.primaryColor.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0.5,
        ),
      ],
    ),
    currentAccountPicture: CircleAvatar(
      backgroundColor: Colors.white.withOpacity(0.9),
      child: const Icon(
        Icons.person,
        color: AppTheme.primaryColor,
        size: 30,
      ),
    ),
    accountName: const Text(
      'John Doe',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
    accountEmail: const Text(
      'john.doe@example.com',
      style: TextStyle(
        fontSize: 14,
        color: Colors.white70,
      ),
    ),
  );

  return Drawer(
    backgroundColor: Colors.transparent,
    elevation: 0,
    width: MediaQuery.of(context).size.width * 0.75, // 75% of screen width
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).brightness == Brightness.dark
                ? AppTheme.darkSurface.withOpacity(0.97)
                : AppTheme.lightSurface.withOpacity(0.97),
            Theme.of(context).brightness == Brightness.dark
                ? AppTheme.darkSurface.withOpacity(0.87)
                : AppTheme.lightSurface.withOpacity(0.87),
          ],
          stops: const [0.3, 1.0],
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.04),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(4, 0),
            spreadRadius: 1,
          ),
        ],
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          drawerHeader,
          
          // Home / Discover
          _buildDrawerItem(
            icon: Icons.explore_rounded,
            text: 'Discover',
            isSelected: currentIndexx == 0,
            onTap: () {
              setState(() {
                Navigator.pop(context);
                if (showAI) {
                  onButtonPressedd();
                }
              });
            },
            context: context,
          ),
          
          // Buddies
          _buildDrawerItem(
            icon: Icons.group_rounded,
            text: 'Buddies',
            isSelected: currentIndexx == 1,
            onTap: () {
              setState(() {
                Navigator.pop(context);
                if (showAI) {
                  onButtonPressedd();
                }
                if (currentIndexx != 1) {
                  currentIndexx = 1;
                }
              });
            },
            context: context,
          ),
          
          // My Trips
          _buildDrawerItem(
            icon: Icons.flight_rounded,
            text: 'My Trips',
            isSelected: currentIndexx == 2,
            onTap: () {
              setState(() {
                Navigator.pop(context);
                if (showAI) {
                  onButtonPressedd();
                }
                if (currentIndexx != 2) {
                  currentIndexx = 2;
                }
              });
            },
            context: context,
          ),
          
          // Profile
          _buildDrawerItem(
            icon: Icons.person_rounded,
            text: 'Profile',
            isSelected: currentIndexx == 3,
            onTap: () {
              setState(() {
                Navigator.pop(context);
                if (showAI) {
                  onButtonPressedd();
                }
                if (currentIndexx != 3) {
                  currentIndexx = 3;
                }
              });
            },
            context: context,
          ),
          
          const Divider(height: 32, thickness: 1),
          
          // AI Assistant
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor.withOpacity(0.9),
                  AppTheme.primaryColor.withBlue(AppTheme.primaryColor.blue + 20).withOpacity(0.8),
                ],
                stops: const [0.3, 1.0],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(
                Icons.auto_awesome,
                color: Colors.white.withOpacity(0.95),
              ),
              title: Text(
                'AI Assistant',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                if (!showAI) {
                  onButtonPressedd();
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          
          // Settings
          _buildDrawerItem(
            icon: Icons.settings_rounded,
            text: 'Settings',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings
            },
            context: context,
          ),
          
          // Help & Support
          _buildDrawerItem(
            icon: Icons.help_outline_rounded,
            text: 'Help & Support',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              // Navigate to help
            },
            context: context,
          ),
          
          // Divider between regular options and sign out
          const Divider(height: 32, thickness: 1),
          
          // Sign out option
          _buildDrawerItem(
            icon: Icons.logout_rounded,
            text: 'Sign Out',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              // Handle sign out
            },
            context: context,
            isDestructive: true,
          ),
          
          // App version information with subtle styling
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Triperry v1.0.0',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}

// Helper method to build consistent drawer items with enhanced styling
Widget _buildDrawerItem({
  required IconData icon,
  required String text,
  required bool isSelected,
  required VoidCallback onTap,
  required BuildContext context,
  bool isDestructive = false,
}) {
  final Color iconColor = isDestructive 
      ? Colors.redAccent.withOpacity(0.9)
      : isSelected
          ? AppTheme.primaryColor
          : Theme.of(context).iconTheme.color!.withOpacity(0.8);
          
  final Color textColor = isDestructive 
      ? Colors.redAccent.withOpacity(0.9) 
      : isSelected
          ? AppTheme.primaryColor
          : Theme.of(context).textTheme.titleMedium!.color!.withOpacity(0.85);
          
  final FontWeight fontWeight = isSelected ? FontWeight.w600 : FontWeight.normal;

  // Background color/gradient for selected item
  final BoxDecoration? decoration = isSelected 
      ? BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppTheme.primaryColor.withOpacity(0.15),
              AppTheme.primaryColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.15),
            width: 0.8,
          ),
        )
      : null;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: decoration,
    child: ListTile(
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: fontWeight,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
    ),
  );
}
