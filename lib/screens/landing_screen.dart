import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import 'auth_wrapper.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'package:google_fonts/google_fonts.dart';

// Landing page data model
class LandingPageData {
  final String image;
  final String title;
  final String description;
  final Color color;

  const LandingPageData({
    required this.image,
    required this.title,
    required this.description,
    required this.color,
  });
}

// Landing page content
class LandingContent {
  static const List<LandingPageData> pages = [
    LandingPageData(
      image: 'assets/images/landing/page1.png',
      title: 'Smart Healthcare\nAt Your Fingertips',
      description:
          'Track your health progress and manage appointments with ease',
      color: Color(0xFF1A73E8),
    ),
    LandingPageData(
      image: 'assets/images/landing/page2.png',
      title: 'Personalized Care\nJust For You',
      description: 'Get treatment plans tailored to your specific condition',
      color: Color(0xFF34A853),
    ),
    LandingPageData(
      image: 'assets/images/landing/page3.png',
      title: 'Stay Connected\nWith Your Doctor',
      description: 'Direct communication with your healthcare team',
      color: Color(0xFFEA4335),
    ),
  ];
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // New animations for floating icons
  final List<GlobalKey> _iconKeys = List.generate(3, (_) => GlobalKey());
  final List<AnimationController> _iconAnimControllers = [];

  bool _isButtonHovered = false;
  bool _isSignInHovered = false;
  final List<bool> _isFloatingIconHovered = [false, false, false];

  @override
  void initState() {
    super.initState();
    _setupAnimations();

    // Create delayed animations for floating icons
    Future.delayed(const Duration(milliseconds: 800), () {
      _animateFloatingIcons();
    });
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  void _animateFloatingIcons() {
    for (int i = 0; i < 3; i++) {
      // Animate each floating icon with a delay
      Future.delayed(Duration(milliseconds: i * 300), () {
        if (mounted) {
          setState(() {
            _isFloatingIconHovered[i] = true;
          });
          Future.delayed(const Duration(milliseconds: 150), () {
            if (mounted) {
              setState(() {
                _isFloatingIconHovered[i] = false;
              });
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _iconAnimControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // Use black for background with blue accent color
    const backgroundColor = Colors.black;
    const textColor = Colors.white;
    final secondaryTextColor = Colors.grey[400];
    const primaryBlue = AppTheme.deepNavy; // Darker blue for button

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Image with gradient fade to black
                    _buildBlendedImageSection(size, backgroundColor),

                    // Content section with padding - removed top padding
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCatchyPhrase(textColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fixed bottom slider-style button and sign in link
            Column(
              children: [
                _buildSliderButton(primaryBlue, backgroundColor),
                const SizedBox(height: 16),
                _buildSignInLink(AppTheme.lightBlue, secondaryTextColor!),
                const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlendedImageSection(Size size, Color backgroundColor) {
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      // Removed any margin/padding that might create separation
      child: Stack(
        children: [
          // Doctor image with parallax effect on scroll
          _buildParallaxImage('assets/images/landing/page1.jpeg'),

          // Gradient overlay that fades to black at the bottom - improved for seamless blend
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.9),
                    Colors.black,
                  ],
                  stops: const [0.0, 0.4, 0.6, 0.75, 0.9, 1.0],
                ),
              ),
            ),
          ),

          // Floating elements with hover effect
          Positioned(
            top: 40,
            right: 30,
            child: _buildFloatingIcon(Icons.favorite, Colors.red, 0),
          ),
          Positioned(
            bottom: 100,
            left: 30,
            child: _buildFloatingIcon(
                Icons.medical_services, AppTheme.lightBlue, 1),
          ),
          Positioned(
            top: 100,
            left: 40,
            child: _buildFloatingIcon(Icons.monitor_heart, Colors.lightBlue, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildParallaxImage(String imagePath) {
    return Positioned.fill(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          // Add a small parallax effect on scroll
          // This effect is subtle and doesn't require setState
          return true;
        },
        child: Hero(
          tag: 'landing_image',
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            // Add a small animation on load
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              return AnimatedOpacity(
                opacity: frame != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCatchyPhrase(Color textColor) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        // Removed top padding to avoid a gap
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black, // Match background exactly - no opacity
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAnimatedText('Get reminders for medications,', textColor,
                delay: 300),
            _buildAnimatedText('book appointments,', textColor, delay: 600),
            _buildAnimatedText('and keep lab records', textColor, delay: 900),
            _buildAnimatedText('all in one app', AppTheme.lightBlue,
                delay: 1200),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedText(String text, Color color, {required int delay}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      // Add a delay to create a staggered animation effect
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(30 * (1 - value), 0),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: color,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingIcon(IconData icon, Color color, int index) {
    // Scale animation based on hover state
    final scale = _isFloatingIconHovered[index] ? 1.2 : 1.0;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isFloatingIconHovered[index] = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isFloatingIconHovered[index] = false;
        });
      },
      child: TweenAnimationBuilder<double>(
        key: _iconKeys[index],
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value * (0.8 + (scale - 1.0) * 0.2),
            child: AnimatedScale(
              scale: scale,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              child: child,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color
                    .withOpacity(_isFloatingIconHovered[index] ? 0.5 : 0.3),
                spreadRadius: _isFloatingIconHovered[index] ? 2 : 1,
                blurRadius: _isFloatingIconHovered[index] ? 8 : 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildSliderButton(Color primaryColor, Color backgroundColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isButtonHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isButtonHovered = false;
          });
        },
        child: GestureDetector(
          onTap: () {
            // Add a small scale animation on tap
            setState(() {
              _isButtonHovered = true;
            });

            Future.delayed(const Duration(milliseconds: 150), () {
              if (mounted) {
                setState(() {
                  _isButtonHovered = false;
                });

                // Navigate after animation completes
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const AuthWrapper(child: RegisterScreen()),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                );
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 60,
            decoration: BoxDecoration(
              color: _isButtonHovered ? AppTheme.accentColor : primaryColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(_isButtonHovered ? 0.5 : 0.3),
                  blurRadius: _isButtonHovered ? 12 : 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    'Get Started',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  right: _isButtonHovered ? 12 : 4,
                  top: 4,
                  bottom: 4,
                  child: Container(
                    width: 52,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: _isButtonHovered
                          ? AppTheme.accentColor
                          : primaryColor,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInLink(Color primaryColor, Color textColor) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isSignInHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isSignInHovered = false;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account? ',
            style: GoogleFonts.inter(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const AuthWrapper(child: LoginScreen()),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.inter(
                color: primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                decoration: _isSignInHovered
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
              child: const Text('Sign in'),
            ),
          ),
        ],
      ),
    );
  }
}
