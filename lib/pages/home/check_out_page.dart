import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:glow_and_go/models/appointment_model.dart';
import 'package:glow_and_go/models/barber_model.dart';
import 'package:glow_and_go/models/service_model.dart';
import 'package:glow_and_go/pages/home/reminder_page.dart';
import 'package:glow_and_go/service/appointment_service.dart';
import 'package:glow_and_go/widgets/catch_profile_image.dart';
import 'package:glow_and_go/widgets/loading_dialog.dart' show LoadingDialog;
import 'package:provider/provider.dart';

import '../../config/app_config.dart';
import '../../provider/salon_provider.dart';
import '../../utils/toast_helper.dart';

class CheckOutPage extends StatelessWidget {
  final ServiceModel serviceModel;
  final BarberModel barberModel;
  final String time;
  final List<ServiceModel> selectedServices;
  final DateTime selectedDate;
  final TextEditingController noteController;

  const CheckOutPage({
    super.key,
    required this.barberModel,
    required this.serviceModel,
    required this.selectedServices,
    required this.noteController,
    required this.selectedDate,
    required this.time,
  });

  int _calculateTotalPrice() {
    int total = serviceModel.price; // Start with the main service price
    for (var service in selectedServices) {
      total += service.price; // Add the price of each selected service
    }
    return total;
  }

  Future<void> _markSlotAsBooked(
    String barberId,
    DateTime selectedDate,
    String selectedTimeRange,
  ) async {
    final barberRef = FirebaseFirestore.instance
        .collection("salons")
        .doc(AppConfig.salonId)
        .collection('barbers')
        .doc(barberId);

    final doc = await barberRef.get();
    if (!doc.exists) return;

    List<dynamic> slots = doc.data()?['availableSlots'] ?? [];

    // 🔥 Extract the start time from "4:59 AM - 5:29 AM"
    final startTimeString = selectedTimeRange.split('-').first.trim();

    // 🕒 Parse it using intl
    final timeFormat = DateFormat.jm(); // like 4:59 AM
    final parsedTime = timeFormat.parse(startTimeString);

    // 🧠 Combine date + time into DateTime
    final combinedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    final targetIso = combinedDateTime.toIso8601String();

    final updatedSlots = slots.map((slot) {
      if (slot['time'] == targetIso) {
        print(slot['time']);
        return {'time': slot['time'], 'isBooked': true};
      }
      return slot;
    }).toList();

    await barberRef.update({'availableSlots': updatedSlots});

    print("Slot $targetIso marked as booked.");
  }

  Future<void> bookAppointmentFlow(BuildContext context) async {
    try {
      LoadingDialog.show(context, message: "Booking...");

      final salonProvider = Provider.of<SalonProvider>(context, listen: false);
      final salon = salonProvider.salon;

      if (salon == null) {
        LoadingDialog.hide(context);
        ToastHelper.show('Salon data not available.');
        return;
      }

      final userId = FirebaseAuth.instance.currentUser!.uid;

      // 🔍 STEP 1: Check if user is blocked
      final userDoc = await FirebaseFirestore.instance
          .collection('salons')
          .doc(AppConfig.salonId)
          .collection('users')
          .doc(userId)
          .get();

      final isBlocked = userDoc.exists && userDoc.data()?['is_blocked'] == true;

      if (isBlocked) {
        LoadingDialog.hide(context);
        ToastHelper.show(
          "🚫 You are blocked by the salon admin. You cannot book an appointment.",
        );
        return;
      }

      // 🔍 STEP 2: Check if appointment already exists
      final existing = await FirebaseFirestore.instance
          .collection("salons")
          .doc(AppConfig.salonId)
          .collection("appointments")
          .where("userId", isEqualTo: userId)
          .where("barberId", isEqualTo: barberModel.id)
          .where("serviceId", isEqualTo: serviceModel.id)
          .where("status", whereIn: ["pending", "confirmed"])
          .get();

      if (existing.docs.isNotEmpty) {
        LoadingDialog.hide(context);
        ToastHelper.show(
          "You already booked this service. Please select another one.",
        );
        return;
      }

      // ✅ STEP 3: Proceed with booking only if not blocked
      final appointment = AppointmentModel(
        currency: salon.currency,
        userId: userId,
        barberId: barberModel.id,
        price: serviceModel.price.toDouble(),
        date: selectedDate,
        orderBy: barberModel.createdBy,
        time: time,
        status: 'pending',
        note: noteController.text,
        id: '',
        serviceId: serviceModel.id,
        timestamp: Timestamp.now(),
      );

      await _markSlotAsBooked(barberModel.id, selectedDate, time);

      await AppointmentService().bookAppointment(
        context,
        AppConfig.salonId,
        appointment,
      );

      LoadingDialog.hide(context);
      ToastHelper.show('✅ Appointment booked successfully!');

      Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => const ReminderPage()),
        (_) => false,
      );
    } catch (e) {
      ToastHelper.show('❌ Failed to book appointment.');
      debugPrint('Booking error: $e');
      LoadingDialog.hide(context);
    }
  }

  // Future<void> bookAppointmentFlow(BuildContext context) async {
  //   try {
  //     LoadingDialog.show(context, message: "Booking...");

  //     // 👇 Get salon from provider
  //     final salonProvider = Provider.of<SalonProvider>(context, listen: false);
  //     final salon = salonProvider.salon;

  //     if (salon == null) {
  //       LoadingDialog.hide(context);
  //       ToastHelper.show(msg: 'Salon data not available.');
  //       return;
  //     }

  //     final appointment = AppointmentModel(
  //       currency: salon.currency, // 👈 using salon currency
  //       userId: FirebaseAuth.instance.currentUser!.uid,
  //       barberId: barberModel.id,
  //       price: serviceModel.price.toDouble(),
  //       date: selectedDate,
  //       orderBy: barberModel.createdBy,
  //       time: time,
  //       status: 'pending',
  //       note: noteController.text,
  //       id: '',
  //       serviceId: serviceModel.id,
  //       timestamp: Timestamp.now(),
  //     );

  //     await _markSlotAsBooked(barberModel.id, selectedDate, time);

  //     await AppointmentService().bookAppointment(
  //       context,
  //       "salonId_yaqoob",
  //       appointment,
  //     );

  //     ToastHelper.show(msg: 'Appointment booked successfully!');

  //     LoadingDialog.hide(context);

  //     Navigator.of(context).pushAndRemoveUntil(
  //       CupertinoPageRoute(builder: (context) => const ReminderPage()),
  //       (_) => false,
  //     );
  //   } catch (e) {
  //     ToastHelper.show(msg: 'Failed to book appointment.');
  //     debugPrint('Booking error: $e');
  //     LoadingDialog.hide(context);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    DateTime date = selectedDate;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<SalonProvider>(
        builder: (context, provider, child) {
          final salon = provider.salon;
          if (salon == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Column(
              children: [
                _buildHeaderImage(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          formatDate(date),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const SizedBox(height: 15),
                        Divider(
                          color: Colors.white.withOpacity(0.3),
                          thickness: 1,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          serviceModel.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            CatchProfileImage(image: serviceModel.image),
                            const SizedBox(width: 10),
                            Text(
                              barberModel.name,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${salon.currency} ${serviceModel.price}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  time,
                                  style: TextStyle(
                                    color: Colors.green.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (selectedServices.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Column(
                            children: selectedServices.map((service) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                child: Row(
                                  children: [
                                    CatchProfileImage(
                                      image: serviceModel.image,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        service.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${salon.currency} ${service.price}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 15),
                          Divider(
                            color: Colors.white.withOpacity(0.3),
                            thickness: 1,
                          ),
                          const SizedBox(height: 15),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              "Total:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "${salon.currency} ${_calculateTotalPrice()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color.fromARGB(255, 173, 111, 107),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Cancellation policy:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "• ",
                              style: TextStyle(color: Colors.white),
                            ),
                            Expanded(
                              child: Text(
                                "Allowed delay is 5 minutes. After that, the appointment is considered missed!",
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "• ",
                              style: TextStyle(color: Colors.white),
                            ),
                            Expanded(
                              child: Text(
                                "Rescheduling is allowed at least 30 minutes earlier.",
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => bookAppointmentFlow(context),
                            child: const Text(
                              "Reserve",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String formatDate(DateTime date) {
    String daySuffix(int day) {
      if (day >= 11 && day <= 13) {
        return 'th';
      }
      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    String formattedDate = DateFormat('EEEE, MMMM d').format(date);
    String suffix = daySuffix(date.day);
    String year = DateFormat('yyyy').format(date);

    return '$formattedDate$suffix, $year';
  }

  Widget _buildHeaderImage(context) {
    return Container(
      height: 280,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/image1.jpg"),
        ),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.0),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
