import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  /// 🔹 Default white-style toast (clean, modern)
  static void show(String message) {
    if (message.isEmpty) return;

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.white,
      textColor: Colors.black87,
      fontSize: 14.0,
    );
  }

  /// 🔹 Success toast (green text on white)
  static void success(String message) {
    _styledToast(message, Colors.green);
  }

  /// 🔹 Error toast (red text on white)
  static void error(String message) {
    _styledToast(message, Colors.redAccent);
  }

  /// 🔹 Info toast (blue text on white)
  static void info(String message) {
    _styledToast(message, Colors.blueAccent);
  }

  /// 🔹 Private method for custom text color with white background
  static void _styledToast(String message, Color textColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.white,
      textColor: textColor,
      fontSize: 14.0,
    );
  }
}
