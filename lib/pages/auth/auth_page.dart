import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../bottom/bottom_bar.dart';
import 'auth_toggle.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snap) {
          if (snap.hasData) {
            return const BottomBar();
          } else {
            return const AuthToggle();
          }
        },
      ),
    );
  }
}
