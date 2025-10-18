import 'package:flutter/material.dart';

class LoadingDialog {
  static void show(BuildContext context, {String message = "Loading..."}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message, style: const TextStyle(fontSize: 16)),
            ],
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}

class ShowLoading extends StatelessWidget {
  const ShowLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
