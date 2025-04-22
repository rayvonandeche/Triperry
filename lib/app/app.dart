import 'package:triperry/app/home_screen.dart';
import 'package:triperry/providers/app_provider.dart';
import 'package:triperry/providers/media_cache_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => MediaCacheProvider()),
      ],
      child: Consumer<AppProvider>(builder: (context, appProvider, _) {
        // Set system UI overlay style based on the theme (including system theme)
        final brightness = MediaQuery.platformBrightnessOf(context);
        final isDarkMode = appProvider.themeMode == ThemeMode.dark ||
            (appProvider.themeMode == ThemeMode.system &&
                brightness == Brightness.dark);

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                isDarkMode ? Brightness.light : Brightness.dark,
            systemNavigationBarColor: isDarkMode ? Colors.black : Colors.white,
            systemNavigationBarIconBrightness:
                isDarkMode ? Brightness.light : Brightness.dark,
          ),
        );

        return MaterialApp(
          title: 'Triperry',
          debugShowCheckedModeBanner: false,
          themeMode: appProvider.themeMode,
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 245, 232, 208),
              brightness: Brightness.light,
            ),
          ).copyWith(
              textTheme: GoogleFonts.ubuntuTextTheme(
            ThemeData.light().textTheme,
          )),
          darkTheme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 245, 232, 208),
              brightness: Brightness.dark,
            ),
          ).copyWith(
              textTheme: GoogleFonts.ubuntuTextTheme(
            ThemeData.dark().textTheme,
          )),
          home: const HomeScreen(),
        );
      }),
    );
  }
}
