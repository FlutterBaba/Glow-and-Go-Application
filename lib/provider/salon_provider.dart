import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glow_and_go/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/salon_model.dart';

class SalonProvider extends ChangeNotifier {
  Salon? _salon;
  Salon? get salon => _salon;

  late final Stream<DocumentSnapshot<Map<String, dynamic>>> _stream;

  SalonProvider() {
    // Pehle cache load karo (fast startup ke liye)
    loadFromPrefs();
    // Firebase realtime listener attach karo
    _listenToSalonChanges();
  }

  /// 🔥 Realtime Firebase listener
  void _listenToSalonChanges() {
    _stream = FirebaseFirestore.instance
        .collection('salons')
        .doc(AppConfig.salonId)
        .snapshots();

    _stream.listen((snapshot) async {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        final updatedSalon = Salon.fromJson(data);

        // Update state in memory
        _salon = updatedSalon;
        notifyListeners();

        // Save to SharedPreferences as JSON
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          "salon_data_${AppConfig.salonId}",
          jsonEncode(updatedSalon.toJson()),
        );

        debugPrint("Salon data updated from Firebase ✅");
      }
    });
  }

  /// 🔥 Load cached salon data (app start par use hota hai)
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString("salon_data_${AppConfig.salonId}");

    if (cached != null && cached.isNotEmpty) {
      try {
        final Map<String, dynamic> json = jsonDecode(cached);
        _salon = Salon.fromJson(json);
        notifyListeners();

        debugPrint("Salon data loaded from cache ✅");
      } catch (e) {
        debugPrint("Salon cache decode error: $e");
      }
    }
  }
}
