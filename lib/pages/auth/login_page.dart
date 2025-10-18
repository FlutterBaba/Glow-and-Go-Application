import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:glow_and_go/style/app_color.dart';
import 'package:glow_and_go/style/text_style.dart';
import 'package:glow_and_go/widgets/cus_buttom.dart';
import 'package:glow_and_go/widgets/loading_dialog.dart';
import '../../provider/auth_provider.dart';
import '../../provider/app_state_provider.dart';
import '../../widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  final void Function()? onPressed; // SignUp
  final void Function()? onForgotPressed; // Forgot password

  const LoginPage({super.key, this.onPressed, this.onForgotPressed});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(30),
              children: [
                const SizedBox(height: 40),
                Text("Welcome Back!", style: h4Bold),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text("Don’t have an account? ", style: p1Regular),
                    GestureDetector(
                      onTap: onPressed,
                      child: Text(
                        "SignUp",
                        style: p1Regular.copyWith(color: AppColor().kpurple3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),

                // Email
                CustomTextField(
                  controller: auth.emailController,
                  label: "Email",
                  hint: "Enter your email address",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // Password with toggle using Selector
                Selector<AuthProvider, bool>(
                  selector: (_, auth) => auth.obscurePassword,
                  builder: (_, obscure, __) {
                    return CustomTextField(
                      controller: auth.passwordController,
                      label: "Password",
                      hint: "Enter your password",
                      obscureText: obscure,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: auth.togglePasswordVisibility,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: onForgotPressed,
                      child: const Text("Forgot password?"),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Login Button
                CusButtom(
                  text: "Login",
                  onPressed: () async {
                    auth.login(context);
                  },
                ),
                const SizedBox(height: 20),

                // Guest Login
                CusButtom(
                  color: Colors.transparent,
                  text: "Continue as Guest",
                  onPressed: () async {
                    auth.loginAsGuest(context);
                  },
                ),
              ],
            ),

            // Global Loading Overlay using Selector
            Selector<AppStateProvider, bool>(
              selector: (_, appState) => appState.isLoading,
              builder: (_, isLoading, __) {
                return isLoading
                    ? const ShowLoading()
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
