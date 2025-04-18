import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'appointment_list_screen.dart';
import 'medication_list_screen.dart';
import 'test_history_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // Removed const to fix linter error
  static final List<Widget> _screens = [
    const DashboardScreen(),
    const AppointmentListScreen(),
    const MedicationListScreen(),
    const TestHistoryScreen(),
  ];

  // Original titles for your app's screens
  static const List<String> _titles = [
    'Dashboard',
    'Appointments',
    'Medications',
    'Test Results',
  ];

  // Icons for your bottom navigation
  static const List<IconData> _icons = [
    Icons.dashboard_rounded,
    Icons.calendar_today_rounded,
    Icons.medication_rounded,
    Icons.assignment_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start with a small bounce animation
    _animationController.forward().then((_) => _animationController.reverse());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final authProvider = Provider.of<AuthProvider>(context);

    // Get colors from theme
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    const Color primaryColor = AppTheme.navyBlue;
    final Color unselectedColor = Colors.grey.shade400;

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),

          // Settings icon in the top right with animation
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: MouseRegion(
              onEnter: (_) => _animationController.forward(),
              onExit: (_) => _animationController.reverse(),
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppTheme.darkCardBlueBlack.withOpacity(0.9)
                        : primaryColor.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode
                            ? Colors.black.withOpacity(0.3)
                            : primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Add a quick pulse animation when pressed
                      _animationController
                          .forward()
                          .then((_) => _animationController.reverse());
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.darkSurfaceBlueBlack : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_titles.length, (index) {
                  bool isSelected = _selectedIndex == index;
                  return Expanded(
                    child: InkWell(
                      onTap: () => _onItemTapped(index),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              children: [
                                Icon(
                                  _icons[index],
                                  color: isSelected
                                      ? primaryColor
                                      : unselectedColor,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                          // Small indicator dot at the bottom for selected tab
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 4,
                            width: isSelected ? 20 : 0,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
