import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glow_and_go/models/appointment_model.dart';
import '../utils/toast_helper.dart';
import '../widgets/loading_dialog.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ✅ Book Appointment under a specific salon
  Future<void> bookAppointment(
    BuildContext context,
    String salonId,
    AppointmentModel appointment,
  ) async {
    try {
      final userId = appointment.userId;

      // 🔍 Step 1: Check if user is blocked
      final userDoc = await _firestore
          .collection('salons')
          .doc(salonId)
          .collection('users')
          .doc(userId)
          .get();

      print(userId);
      // if the user document exists and is_blocked == true
      if (userDoc.exists && userDoc.data()?['is_blocked'] == true) {
        ToastHelper.show('You are blocked by the salon admin.');
        return; // ❌ stop booking
      }

      // if userDoc doesn't exist or not blocked → proceed
      DocumentReference documentReference = _firestore
          .collection('salons')
          .doc(salonId)
          .collection("appointments")
          .doc();

      final newAppointment = AppointmentModel(
        currency: appointment.currency,
        id: documentReference.id,
        userId: appointment.userId,
        barberId: appointment.barberId,
        serviceId: appointment.serviceId,
        orderBy: appointment.orderBy,
        price: appointment.price,
        date: appointment.date,
        time: appointment.time,
        status: appointment.status,
        note: appointment.note,
        timestamp: appointment.timestamp,
        selectedServices: appointment.selectedServices,
        phoneNumber: appointment.phoneNumber,
      );

      await documentReference.set(newAppointment.toJson());
      ToastHelper.show('Appointment booked successfully!');
    } catch (e) {
      LoadingDialog.hide(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to book appointment.")),
      );
      print("❌ Error booking appointment: $e");
    }
  }

  /// ✅ Get Upcoming Appointments for a specific user
  Future<List<AppointmentModel>> getUpcomingAppointments(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collectionGroup("appointments") // search across all salons
          .where("userId", isEqualTo: userId)
          .get();

      return snapshot.docs
          .map(
            (doc) =>
                AppointmentModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .where((appointment) => appointment.date.isAfter(DateTime.now()))
          .toList();
    } catch (e) {
      print("Error fetching upcoming appointments: $e");
      return [];
    }
  }

  /// ✅ Get Past Appointments for a specific user
  Future<List<AppointmentModel>> getPastAppointments(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collectionGroup("appointments")
          .where("userId", isEqualTo: userId)
          .get();

      return snapshot.docs
          .map(
            (doc) =>
                AppointmentModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .where((appointment) => appointment.date.isBefore(DateTime.now()))
          .toList();
    } catch (e) {
      print("Error fetching past appointments: $e");
      return [];
    }
  }

  /// ✅ Cancel Appointment
  Future<void> cancelAppointment(
    String salonId,
    String appointmentId,
    BuildContext context,
  ) async {
    LoadingDialog.show(context, message: "Canceling...");
    try {
      await _firestore
          .collection('salons')
          .doc(salonId)
          .collection("appointments")
          .doc(appointmentId)
          .delete();

      LoadingDialog.hide(context);
      ToastHelper.show('Appointment cancelled successfully');
    } catch (e) {
      LoadingDialog.hide(context);
      print("Error cancelling appointment: $e");
    }
  }
}
