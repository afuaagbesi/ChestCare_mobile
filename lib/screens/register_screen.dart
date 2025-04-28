import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/country_service.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/theme_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedCountry;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  List<Country> _countries = [];
  bool _isLoadingCountries = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      final countries = await CountryService.getCountries();
      setState(() {
        _countries = countries;
        _selectedCountry = countries.isNotEmpty ? countries.first.code : null;
        _isLoadingCountries = false;
      });
    } catch (e) {
      debugPrint('Error loading countries: $e');
      // Use fallback countries if API fails
      setState(() {
        _countries = CountryService.getFallbackCountries();
        _selectedCountry = _countries.isNotEmpty ? _countries.first.code : null;
        _isLoadingCountries = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Using offline country list due to connection issues'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      try {
        await context.read<AuthProvider>().register(
              '${_firstNameController.text} ${_lastNameController.text}',
              _emailController.text,
              _passwordController.text,
            );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final backgroundColor =
        isDarkMode ? AppTheme.darkBgBlueBlack : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtextColor = isDarkMode ? Colors.grey[400] : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background design elements
          Positioned(
            top: -150,
            right: -150,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDarkMode
                    ? AppTheme.accentColor.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDarkMode
                    ? AppTheme.lightBlue.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.1),
              ),
            ),
          ),
          // Main content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with pulse animation
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.8, end: 1.0),
                          duration: const Duration(seconds: 2),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Icon(
                                Icons.medical_services,
                                size: 64,
                                color: isDarkMode
                                    ? AppTheme.lightBlue
                                    : AppTheme.accentColor,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'ChestCare',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create Your Patient Account',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: subtextColor,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildAnimatedRow(
                                children: [
                                  Expanded(
                                    child: _buildAnimatedFormField(
                                      controller: _firstNameController,
                                      label: 'First Name',
                                      hint: 'Enter first name',
                                      delay: 200,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildAnimatedFormField(
                                      controller: _lastNameController,
                                      label: 'Last Name',
                                      hint: 'Enter last name',
                                      delay: 300,
                                    ),
                                  ),
                                ],
                                delay: 200,
                              ),
                              const SizedBox(height: 16),
                              _buildAnimatedFormField(
                                controller: _emailController,
                                label: 'Email',
                                hint: 'Enter your email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                delay: 400,
                              ),
                              const SizedBox(height: 16),
                              _buildAnimatedRow(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: _buildAnimatedFormField(
                                      controller: _phoneController,
                                      label: 'Phone Number',
                                      hint: 'Enter phone number',
                                      icon: Icons.phone_outlined,
                                      keyboardType: TextInputType.phone,
                                      delay: 500,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 2,
                                    child: _buildAnimatedCountryDropdown(
                                        delay: 500),
                                  ),
                                ],
                                delay: 500,
                              ),
                              const SizedBox(height: 16),
                              _buildAnimatedFormField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: 'Create a strong password',
                                icon: Icons.lock_outline,
                                isPassword: true,
                                delay: 600,
                              ),
                              const SizedBox(height: 16),
                              _buildAnimatedFormField(
                                controller: _confirmPasswordController,
                                label: 'Confirm Password',
                                hint: 'Confirm your password',
                                icon: Icons.lock_outline,
                                isPassword: true,
                                isConfirmPassword: true,
                                delay: 700,
                              ),
                              const SizedBox(height: 32),
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeOut,
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: _register,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isDarkMode
                                              ? AppTheme.accentColor
                                              : AppTheme.deepNavy,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: Text(
                                          'Create Account',
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account? ',
                                      style: GoogleFonts.inter(
                                        color: subtextColor,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()),
                                        );
                                      },
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedRow({
    required List<Widget> children,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Row(
        children: children,
      ),
    );
  }

  Widget _buildAnimatedFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    bool isPassword = false,
    bool isConfirmPassword = false,
    TextInputType keyboardType = TextInputType.text,
    int delay = 0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey[500],
          ),
          labelStyle: GoogleFonts.inter(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppTheme.lightBlue
                : AppTheme.accentColor,
          ),
          prefixIcon: icon != null
              ? Icon(
                  icon,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.lightBlue
                      : AppTheme.accentColor,
                )
              : null,
          suffixIcon: isPassword || isConfirmPassword
              ? IconButton(
                  icon: Icon(
                    isPassword
                        ? (_obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined)
                        : (_obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      if (isPassword) {
                        _obscurePassword = !_obscurePassword;
                      } else {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      }
                    });
                  },
                )
              : null,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.darkCardBlueBlack
              : Colors.grey[100],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppTheme.accentColor,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
        style: GoogleFonts.inter(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black87,
        ),
        obscureText: isPassword
            ? _obscurePassword
            : (isConfirmPassword ? _obscureConfirmPassword : false),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          if (keyboardType == TextInputType.emailAddress &&
              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAnimatedCountryDropdown({required int delay}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: _isLoadingCountries
          ? Container(
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkCardBlueBlack
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          : DropdownButtonFormField<String>(
              value: _selectedCountry,
              decoration: InputDecoration(
                labelText: 'Country',
                labelStyle: GoogleFonts.inter(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.lightBlue
                      : AppTheme.accentColor,
                ),
                hintStyle: GoogleFonts.inter(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[400]
                      : Colors.grey[500],
                ),
                prefixIcon: Icon(
                  Icons.public,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.lightBlue
                      : AppTheme.accentColor,
                ),
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkCardBlueBlack
                    : Colors.grey[100],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppTheme.accentColor,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
              ),
              style: GoogleFonts.inter(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
              dropdownColor: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.darkCardBlueBlack
                  : Colors.white,
              items: _countries.map((Country country) {
                return DropdownMenuItem<String>(
                  value: country.code,
                  child: Text(
                    country.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCountry = newValue;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a country';
                }
                return null;
              },
              menuMaxHeight: 300,
              isExpanded: true,
            ),
    );
  }
}
