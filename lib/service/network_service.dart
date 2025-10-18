import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkChecker {
  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<List<ConnectivityResult>>? _subscription;
  static bool _dialogShowing = false;
  static BuildContext? _dialogContext;

  /// Initialize network checking
  static void initialize(BuildContext context) {
    _subscription = _connectivity.onConnectivityChanged.listen((_) async {
      bool connected = await _hasInternet();

      if (!connected && !_dialogShowing) {
        _showNoConnectionDialog(context);
      } else if (connected && _dialogShowing && _dialogContext != null) {
        Navigator.of(_dialogContext!, rootNavigator: true).pop();
        _dialogShowing = false;
        _dialogContext = null;
      }
    });
  }

  /// Check real internet connection
  static Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Show no internet dialog
  static void _showNoConnectionDialog(BuildContext context) {
    _dialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        _dialogContext = dialogContext; // Save dialog context
        return AlertDialog(
          title: const Text("No Internet"),
          content: const Text("Please connect to WiFi or Mobile Data."),
          actions: [
            TextButton(
              onPressed: () async {
                bool connected = await _hasInternet();
                if (connected && _dialogContext != null) {
                  Navigator.of(_dialogContext!, rootNavigator: true).pop();
                  _dialogShowing = false;
                  _dialogContext = null;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("No internet yet. Try again."),
                    ),
                  );
                }
              },
              child: const Text("Retry"),
            ),
          ],
        );
      },
    );
  }

  /// Dispose subscription
  static void dispose() {
    _subscription?.cancel();
  }
}
