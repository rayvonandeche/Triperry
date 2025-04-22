part of './home_screen.dart';

Widget _buildDrawer({
  required BuildContext context,
  required showAI,
  required Function(VoidCallback fn) setState,
  required int currentIndexx,
  required Function() onButtonPressedd,
}) {
  int currentIndex = currentIndexx;
  Function onButtonPressed = onButtonPressedd;
  return Drawer(
    shape: const Border(),
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white.withOpacity(0.8),
                child: Icon(
                  Icons.person,
                  size: 35,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Welcome, Traveler',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'traveler@email.com',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              // Row(
              //   children: [
              //     Chip(
              //       label: Text('3 Trips'),
              //       backgroundColor: Colors.white.withOpacity(0.2),
              //       labelStyle: const TextStyle(color: Colors.white),
              //     ),
              //     const SizedBox(width: 8),
              //     Chip(
              //       label: Text('Explorer'),
              //       backgroundColor: Colors.white.withOpacity(0.2),
              //       labelStyle: const TextStyle(color: Colors.white),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
        // Main Navigation
        ListTile(
          leading: const Icon(Icons.auto_awesome_mosaic_sharp),
          title: const Text('Discover'),
          selected: currentIndex == 0 && !showAI,
          selectedTileColor:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
          onTap: () {
            setState(() => currentIndex = 0);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.auto_stories_rounded),
          title: const Text('Trips'),
          selected: currentIndex == 1 && !showAI,
          selectedTileColor:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
          onTap: () {
            setState(() => currentIndex = 1);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.auto_awesome),
          title: const Text('AI Travel Assistant'),
          selected: showAI,
          selectedTileColor:
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
          onTap: () {
            Navigator.pop(context);
            onButtonPressed();
          },
        ),
        const Divider(),
        // Additional Features
        ListTile(
          leading: const Icon(Icons.bookmark_border),
          title: const Text('Saved Places'),
          onTap: () {
            Navigator.pop(context);
            // Navigate to Saved Places (to be implemented)
          },
        ),
        ListTile(
          leading: const Icon(Icons.map_outlined),
          title: const Text('Explore Map'),
          onTap: () {
            Navigator.pop(context);
            // Navigate to Map (to be implemented)
          },
        ),
        ListTile(
          leading: const Icon(Icons.star_border_rounded),
          title: const Text('Reviews & Ratings'),
          onTap: () {
            Navigator.pop(context);
            // Navigate to Reviews (to be implemented)
          },
        ),
        const Divider(),
        // Settings & Support
        ListTile(
          leading: Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              IconData themeIcon;
              if (appProvider.themeMode == ThemeMode.system) {
                themeIcon = Icons.brightness_auto;
              } else if (appProvider.themeMode == ThemeMode.light) {
                themeIcon = Icons.light_mode;
              } else {
                themeIcon = Icons.dark_mode;
              }
              return Icon(themeIcon);
            },
          ),
          title: const Text('Theme'),
          onTap: () {
            final appProvider =
                Provider.of<AppProvider>(context, listen: false);
            appProvider.toggleTheme();
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Settings'),
          onTap: () {
            Navigator.pop(context);
            // Navigate to Settings (to be implemented)
          },
        ),
        ListTile(
          leading: const Icon(Icons.help_outline_rounded),
          title: const Text('Help & Support'),
          onTap: () {
            Navigator.pop(context);
            // Navigate to Help (to be implemented)
          },
        ),
        // App Info
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Triperry v1.0.0',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
