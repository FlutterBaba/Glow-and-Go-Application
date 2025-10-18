import 'dart:async';
import 'package:flutter/material.dart';
import 'package:glow_and_go/service/auth_service.dart';
import 'package:glow_and_go/utils/toast_helper.dart';
import 'app_state_provider.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isProcessing = false;
  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  // Text Controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  static final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  /// ✅ Signup
  Future<bool> signUp(BuildContext context) async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim();

    if (fullName.isEmpty) {
      ToastHelper.show("Please enter your full name");
      return false;
    }
    if (!emailRegex.hasMatch(email)) {
      ToastHelper.show("Please enter a valid email address");
      return false;
    }
    if (phone.length < 8) {
      ToastHelper.show("Please enter a valid phone number");
      return false;
    }
    if (password.length < 6) {
      ToastHelper.show("Password must be at least 6 characters");
      return false;
    }

    if (_isProcessing) return false;
    _isProcessing = true;

    final appState = Provider.of<AppStateProvider>(context, listen: false);
    appState.startLoading();

    try {
      bool success = await _authService
          .signupCustomer(fullName, email, password, phone)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              ToastHelper.show("Request timed out. Please try again.");
              return false;
            },
          );

      if (success) ToastHelper.show("SignUp successful!");
      return success;
    } catch (e) {
      ToastHelper.show("Something went wrong: $e");
      return false;
    } finally {
      _isProcessing = false;
      appState.stopLoading();
    }
  }

  /// ✅ Login
  Future<bool> login(BuildContext context) async {
    if (_isProcessing) return false;
    _isProcessing = true;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!emailRegex.hasMatch(email)) {
      ToastHelper.show("Please enter a valid email address");
      _isProcessing = false;
      return false;
    }
    if (password.isEmpty) {
      ToastHelper.show("Please enter your password");
      _isProcessing = false;
      return false;
    }

    final appState = Provider.of<AppStateProvider>(context, listen: false);
    appState.startLoading();

    try {
      bool success = await _authService
          .loginWithEmailPassword(email, password)
          .timeout(const Duration(seconds: 12));

      if (success) ToastHelper.show("Login successful!");
      return success;
    } on TimeoutException {
      ToastHelper.show("Login timed out. Check your connection.");
      return false;
    } catch (e) {
      ToastHelper.show("Something went wrong: $e");
      return false;
    } finally {
      _isProcessing = false;
      appState.stopLoading();
    }
  }

  /// ✅ Guest login
  Future<bool> loginAsGuest(BuildContext context) async {
    if (_isProcessing) return false;
    _isProcessing = true;

    final appState = Provider.of<AppStateProvider>(context, listen: false);
    appState.startLoading();

    try {
      bool success = await _authService.loginAsGuest();
      if (success) ToastHelper.show("Login successful!");
      return success;
    } catch (e) {
      ToastHelper.show("Something went wrong: $e");
      return false;
    } finally {
      _isProcessing = false;
      appState.stopLoading();
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
