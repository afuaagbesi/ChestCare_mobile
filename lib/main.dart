import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/appointment_provider.dart';
import 'screens/auth_wrapper.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart' as dashboard;
import 'screens/landing_screen.dart';
import 'screens/appointment_list_screen.dart';
import 'screens/medication_list_screen.dart';
import 'screens/test_history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for a more immersive experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.darkBgBlueBlack,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ],
      child: const ChestCareApp(),
    ),
  );
}

// Enhanced page transition animation
class EnhancedPageTransition extends PageRouteBuilder {
  final Widget page;
  final bool fade;

  EnhancedPageTransition({
    required this.page,
    this.fade = true,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Define our animations
            var fadeAnimation = fade
                ? Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  )
                : const AlwaysStoppedAnimation(1.0);

            var scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            );

            var slideAnimation = Tween<Offset>(
              begin: const Offset(0.05, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            );

            // Apply multiple animations
            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: child,
                ),
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 300),
        );
}

class ChestCareApp extends StatelessWidget {
  const ChestCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'ChestCare Patient',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isAuthenticated) {
            return const HomeScreen();
          }
          return const AuthWrapper(child: LandingScreen());
        },
      ),
      onGenerateRoute: (settings) {
        // Define a function to create routes with animations
        Widget page;

        // Determine which page to show based on route name
        switch (settings.name) {
          case '/login':
            page = const AuthWrapper(child: LoginScreen());
            break;
          case '/register':
            page = const AuthWrapper(child: RegisterScreen());
            break;
          case '/forgot-password':
            page = const ForgotPasswordScreen();
            break;
          case '/home':
            page = const HomeScreen();
            break;
          case '/dashboard':
            page = const dashboard.DashboardScreen();
            break;
          case '/appointments':
            page = const AppointmentListScreen();
            break;
          case '/medications':
            page = const MedicationListScreen();
            break;
          case '/test-history':
            page = const TestHistoryScreen();
            break;
          case '/settings':
            page = const SettingsScreen();
            break;
          default:
            return null;
        }

        // Return the enhanced animated route
        return EnhancedPageTransition(page: page);
      },
    );
  }
}
