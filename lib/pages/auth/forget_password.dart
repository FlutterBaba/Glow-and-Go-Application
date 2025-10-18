import 'package:flutter/material.dart';
import 'package:glow_and_go/service/auth_service.dart';
import 'package:glow_and_go/widgets/cus_buttom.dart';

import '../../utils/toast_helper.dart';
import '../../widgets/loading_dialog.dart';

class ForgetPasswordPage extends StatefulWidget {
  final VoidCallback? onBack; // 🔹 back callback

  const ForgetPasswordPage({super.key, this.onBack});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  void _resetPassword() async {
    String email = _emailController.text.trim();
    if (email.isEmpty || !email.contains("@")) {
      ToastHelper.show("Please enter a valid email address");
      return;
    }

    setState(() => _isLoading = true);

    bool success = await _authService.resetPassword(email);

    setState(() => _isLoading = false);

    if (success) {
      ToastHelper.show("Password reset email sent! Please check your inbox.");
      _emailController.clear();
      widget.onBack?.call(); // 🔹 back to login automatically
    } else {
      ToastHelper.show("Failed to send reset email. Try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack, // 🔹 back to login
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter your email to reset your password',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                CusButtom(onPressed: _resetPassword, text: "Reset Password"),
              ],
            ),
          ),
          // Loading Overlay
          if (_isLoading) ShowLoading(),
        ],
      ),
    );
  }
}
