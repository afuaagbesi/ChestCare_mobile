import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChestCare Patient',
      theme: AppTheme.lightTheme,
      home: child,
    );
  }
}
