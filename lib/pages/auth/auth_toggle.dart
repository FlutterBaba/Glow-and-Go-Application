import 'package:flutter/material.dart';
import 'package:glow_and_go/pages/auth/forget_password.dart';
import 'login_page.dart';
import 'signup_page.dart';

class AuthToggle extends StatefulWidget {
  const AuthToggle({super.key});

  @override
  State<AuthToggle> createState() => _AuthToggleState();
}

enum AuthPageType { login, signup, forgot }

class _AuthToggleState extends State<AuthToggle> {
  AuthPageType currentPage = AuthPageType.login;

  void goToLogin() => setState(() => currentPage = AuthPageType.login);
  void goToSignup() => setState(() => currentPage = AuthPageType.signup);
  void goToForgotPassword() =>
      setState(() => currentPage = AuthPageType.forgot);

  @override
  Widget build(BuildContext context) {
    switch (currentPage) {
      case AuthPageType.signup:
        return SignUpPage(onPressed: goToLogin);
      case AuthPageType.forgot:
        return ForgetPasswordPage(onBack: goToLogin);
      default:
        return LoginPage(
          onPressed: goToSignup,
          onForgotPressed: goToForgotPassword,
        );
    }
  }
}
