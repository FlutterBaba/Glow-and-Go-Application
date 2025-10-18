import 'package:flutter/material.dart';

class DeleteAccountDialog {
  static Future<void> show(
    BuildContext context, {
    required String salonId,
    required String email,
    required Future<void> Function(
      BuildContext context,
      String salonId,
      String email,
      String password,
    )
    onDelete,
  }) async {
    final TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      barrierDismissible: false, // must press cancel or delete
      builder: (ctx) {
        bool isDeleting = false; // 👈 local state

        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: const Text("Delete Account"),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Email (readonly)
                    TextFormField(
                      initialValue: email,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Password (input)
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isDeleting
                      ? null // disable while deleting
                      : () {
                          Navigator.of(ctx).pop(); // cancel
                        },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: isDeleting
                      ? null // disable button while deleting
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setState(() => isDeleting = true);

                            final password = passwordController.text.trim();
                            await onDelete(ctx, salonId, email, password);

                            setState(() => isDeleting = false);
                          }
                        },
                  child: isDeleting
                      ? const Text("Deleting...") // 👈 loading text
                      : const Text("Delete"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
