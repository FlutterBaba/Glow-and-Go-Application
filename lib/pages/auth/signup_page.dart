import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:glow_and_go/style/app_color.dart';
import 'package:glow_and_go/style/text_style.dart';
import 'package:glow_and_go/widgets/cus_buttom.dart';
import 'package:glow_and_go/widgets/loading_dialog.dart';
import '../../provider/app_state_provider.dart';
import '../../provider/auth_provider.dart';
import '../../widgets/custom_text_field.dart';

class SignUpPage extends StatelessWidget {
  final void Function()? onPressed;
  const SignUpPage({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(30),
            children: [
              const SizedBox(height: 40),
              Text("Sign Up", style: h4Bold),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text("Already have an account? ", style: p1Regular),
                  GestureDetector(
                    onTap: onPressed,
                    child: Text(
                      "Login",
                      style: p1Regular.copyWith(color: AppColor().kpurple3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),

              // Full Name
              CustomTextField(
                controller: auth.fullNameController,
                label: "Full Name",
                hint: "Enter your full name",
              ),
              const SizedBox(height: 20),

              // Email
              CustomTextField(
                controller: auth.emailController,
                label: "Email",
                hint: "Enter your email address",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Phone
              CustomTextField(
                controller: auth.phoneController,
                label: "Phone Number",
                hint: "Enter your phone number",
                keyboardType: TextInputType.phone,
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
              const SizedBox(height: 40),

              CusButtom(
                text: "Sign Up",
                onPressed: () async {
                  auth.signUp(context); // Toast already in provider
                },
              ),
            ],
          ),

          // Global Loading Overlay using Selector
          Selector<AppStateProvider, bool>(
            selector: (_, appState) => appState.isLoading,
            builder: (_, isLoading, __) {
              return isLoading ? const ShowLoading() : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
