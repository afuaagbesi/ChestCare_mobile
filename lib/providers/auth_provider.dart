import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  String _userName = 'John Doe';
  String _userEmail = 'john.doe@example.com';
  String _profileImage = 'https://randomuser.me/api/portraits/men/79.jpg';
  bool _appointmentNotifications = true;
  bool _medicationNotifications = true;

  AuthProvider() {
    _loadAuthState();
  }

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get profileImage => _profileImage;
  bool get appointmentNotifications => _appointmentNotifications;
  bool get medicationNotifications => _medicationNotifications;

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _userName = prefs.getString('userName') ?? 'John Doe';
    _userEmail = prefs.getString('userEmail') ?? 'john.doe@example.com';
    _profileImage = prefs.getString('profileImage') ??
        'https://randomuser.me/api/portraits/men/79.jpg';
    _appointmentNotifications =
        prefs.getBool('appointmentNotifications') ?? true;
    _medicationNotifications = prefs.getBool('medicationNotifications') ?? true;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    // TODO: Implement actual login logic
    _currentUser = User(
      id: '1',
      name: 'John Doe',
      email: email,
      disease: 'Asthma',
      medications: ['Inhaler', 'Prednisone'],
    );
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    // TODO: Implement actual registration logic
    _currentUser = User(
      id: '1',
      name: name,
      email: email,
      disease: 'Asthma',
      medications: ['Inhaler', 'Prednisone'],
    );
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> updateProfile({String? name, String? image}) async {
    if (name != null) {
      _userName = name;
    }

    if (image != null) {
      _profileImage = image;
    }

    final prefs = await SharedPreferences.getInstance();
    if (name != null) {
      await prefs.setString('userName', name);
    }

    if (image != null) {
      await prefs.setString('profileImage', image);
    }

    notifyListeners();
  }

  Future<void> toggleAppointmentNotifications() async {
    _appointmentNotifications = !_appointmentNotifications;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('appointmentNotifications', _appointmentNotifications);

    notifyListeners();
  }

  Future<void> toggleMedicationNotifications() async {
    _medicationNotifications = !_medicationNotifications;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('medicationNotifications', _medicationNotifications);

    notifyListeners();
  }

  Future<void> forgotPassword(String email) async {
    try {
      // TODO: Implement actual password reset logic with backend
      // This is a mock implementation that simulates a successful password reset request

      // Validate email format first
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        throw Exception('Please enter a valid email address');
      }

      // Log the password reset attempt (in a real app, this would be server-side)
      print('Password reset requested for: $email');

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // For demo purposes, we'll just return success if the email matches our test user
      // In a real implementation, this would trigger an email to the user
      if (email.toLowerCase() != _userEmail.toLowerCase()) {
        // For demo purposes, we allow any email, but log a warning if it's not our test user
        print('Warning: Password reset requested for unknown email: $email');
      }

      // In a real app, you would:
      // 1. Call your API to request a password reset
      // 2. The API would generate a secure token
      // 3. The API would send an email with a link containing that token
      // 4. When the user clicks the link, they'd be taken to a reset page

      return;
    } catch (e) {
      print('Error in forgotPassword: $e');
      rethrow; // Re-throw the exception to be handled by the UI
    }
  }
}
