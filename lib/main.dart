import 'package:triperry/app/home_screen.dart';
import 'package:triperry/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triperry/services/auth_service.dart';
import 'package:triperry/screens/auth/login_screen.dart';
import 'package:triperry/screens/auth/signup_screen.dart';
import 'package:triperry/screens/splash/animated_splash_screen.dart';
import 'package:triperry/screens/ai/ai_screen_modular.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Triperry',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primaryColor),
        useMaterial3: true,
      ),
      home: const AnimatedSplashScreen(nextScreen: HomeScreen()),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/ai': (context) => const AiPageModular(),
      },
    );
  }
}
