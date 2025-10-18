import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  int _loadingCount = 0;

  bool get isLoading => _loadingCount > 0;

  void startLoading() {
    _loadingCount++;
    notifyListeners();
  }

  void stopLoading() {
    _loadingCount--;
    if (_loadingCount < 0) _loadingCount = 0;
    notifyListeners();
  }
}
