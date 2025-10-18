// import 'package:flutter/material.dart';
// import '../models/barber_model.dart';
// import '../service/barber_service.dart';

// class BarberProvider extends ChangeNotifier {
//   final String salonId;

//   BarberProvider({required this.salonId}) {
//     fetchBarbers();
//   }

//   bool isLoading = true;
//   List<BarberModel> barbers = [];

//   Future<void> fetchBarbers() async {
//     try {
//       isLoading = true;
//       notifyListeners();

//       barbers = await BarberService().getBarbers(salonId);

//     } catch (e) {
//       debugPrint("Error fetching barbers: $e");
//       barbers = [];
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
// }
