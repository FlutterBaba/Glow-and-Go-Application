// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glow_and_go/session_manager/user_session.dart';
import '../config/app_config.dart';
import '../models/user_model.dart';
import '../utils/firebase_errors.dart';
import '../utils/toast_helper.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> signupCustomer(
    String fullName,
    String email,
    String password,
    String phoneNumber,
  ) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      String userId = userCred.user!.uid;

      UserModel userModel = UserModel(
        uid: userId,
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
      );

      await _firestore
          .collection("salons")
          .doc(AppConfig.salonId)
          .collection("users")
          .doc(userId)
          .set(userModel.toJson(), SetOptions(merge: true));

      await UserSession.setUser(userModel);

      return true; // ✅ success
    } on FirebaseAuthException catch (e) {
      ToastHelper.show(getFirebaseAuthError(e.code));
      return false;
    } catch (e) {
      ToastHelper.show("Something went wrong. Please try again.");
      return false;
    }
  }

  Future<bool> loginWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCredential.user;
      if (user == null) {
        ToastHelper.show("User not found.");
        return false;
      }

      final userDoc = await _firestore
          .collection("salons")
          .doc(AppConfig.salonId)
          .collection("users")
          .doc(user.uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        ToastHelper.show("Account not registered in this salon.");
        return false;
      }

      final userModel = UserModel.fromJson(userDoc.data()!);
      await UserSession.setUser(userModel);

      return true;
    } on FirebaseAuthException catch (e) {
      // ✅ Show specific Firebase Auth error
      ToastHelper.show(getFirebaseAuthError(e.code));
      debugPrint("FirebaseAuthException: ${e.code}");
      return false;
    } catch (e, st) {
      // ✅ Catch any unexpected error
      debugPrint("Unexpected login error: $e\n$st");
      ToastHelper.show("Something went wrong. Please try again.");
      return false;
    }
  }

  Future<bool> loginAsGuest() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();

      User? user = userCredential.user;
      if (user != null) {
        // You can store session here if needed
        return true; // ✅ success
      }
      return false;
    } on FirebaseAuthException catch (e) {
      ToastHelper.show(getFirebaseAuthError(e.code));
      return false;
    } catch (e) {
      ToastHelper.show("Error: ${e.toString()}");
      return false;
    }
  }

  // Logout Method
  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      ToastHelper.show("Logged out successfully");
    } catch (e) {
      print("Logout error: ${e.toString()}");
      ToastHelper.show("Error: ${e.toString()}");
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      ToastHelper.show('Error: ${e.toString()}');
      return false;
    }
  }

  /// ✅ Delete Account (Firestore + Firebase Auth)
  Future<bool> deleteAccount(
    String salonId,
    String email,
    String password,
  ) async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        // 🔹 Re-authenticate the user before deletion
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);

        // 🔹 Delete user data from Firestore
        await _firestore
            .collection('salons')
            .doc(salonId)
            .collection('users')
            .doc(user.uid)
            .delete();

        // 🔹 Delete user from Firebase Auth tab
        await user.delete();

        return true; // ✅ success
      } else {
        throw "No user is currently signed in.";
      }
    } on FirebaseAuthException catch (e) {
      ToastHelper.show(getFirebaseAuthError(e.code.toString()));
      return false;
    } catch (e) {
      ToastHelper.show("Error: $e");
      return false;
    }
  }
}
