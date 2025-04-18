import 'package:flutter/material.dart';

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
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;
  bool _isLastPage = false;

  @override
  void initState() {
    super.initState();
    // Add debug print for asset loading
    print('Attempting to load asset: ${LandingContent.pages[0].image}');
    _setupAnimations();
    _startAutoSlide();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the asset is included in the bundle
    DefaultAssetBundle.of(context)
        .load(LandingContent.pages[0].image)
        .then((_) => print('Asset found in bundle'))
        .catchError((error) => print('Asset not found in bundle: $error'));
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        if (_currentPage < LandingContent.pages.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
        _startAutoSlide();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      _isLastPage = _currentPage == LandingContent.pages.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Professional medical color palette
    const primaryBlue = Color(0xFF2B6CB0); // Trustworthy blue
    const accentBlue = Color(0xFF4299E1); // Lighter accent blue
    const surfaceBlue = Color(0xFFEBF8FF); // Very light blue for backgrounds
    const textDark = Color(0xFF2D3748); // Dark gray for primary text
    const textLight = Color(0xFF718096); // Light gray for secondary text

    return Scaffold(
      backgroundColor: surfaceBlue,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildPage(
                title: LandingContent.pages[index].title,
                subtitle: LandingContent.pages[index].description,
                image: LandingContent.pages[index].image,
                textDark: textDark,
                textLight: textLight,
              );
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _buildLogo(primaryBlue),
              ),
            ),
          ),
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String subtitle,
    required String image,
    required Color textDark,
    required Color textLight,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 300,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: TextStyle(
              color: textDark,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: TextStyle(
              color: textLight,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.medical_services_rounded, color: color),
        const SizedBox(width: 8),
        Text(
          'ChestCare',
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator(Color primaryColor, Color accentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? primaryColor
                : accentColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(Color primaryColor) {
    final isLastPage = _currentPage == 2;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (isLastPage) {
            // Navigate to register screen
            Navigator.pushReplacementNamed(context, '/register');
          } else {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          isLastPage ? 'Get Started' : 'Next',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInLink(Color primaryColor, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text(
            'Sign In',
            style: TextStyle(
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    // Professional medical color palette
    const primaryBlue = Color(0xFF2B6CB0); // Trustworthy blue
    const accentBlue = Color(0xFF4299E1); // Lighter accent blue
    const textLight = Color(0xFF718096); // Light gray for secondary text

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.white.withOpacity(0.0),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPageIndicator(primaryBlue, accentBlue),
              const SizedBox(height: 32),
              _buildActionButton(primaryBlue),
              const SizedBox(height: 16),
              _buildSignInLink(primaryBlue, textLight),
            ],
          ),
        ),
      ),
    );
  }
}
