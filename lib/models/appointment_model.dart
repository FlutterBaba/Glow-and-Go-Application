import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glow_and_go/models/barber_model.dart';
import 'package:glow_and_go/models/service_model.dart';

class AppointmentModel {
  String userId;
  String barberId;
  String orderBy;
  String currency;
  double price;
  DateTime date;
  String time;
  String id;
  String status;
  String? note;
  String serviceId;
  Timestamp timestamp;
  BarberModel? barberModel;
  ServiceModel? serviceModel;

  // New fields
  List<String>? selectedServices;
  String? phoneNumber;

  AppointmentModel({
    required this.userId,
    required this.orderBy,
    required this.id,
    required this.barberId,
    required this.price,
    required this.date,
    required this.time,
    required this.status,
    this.note,
    required this.serviceId,
    required this.timestamp,
    this.barberModel,
    this.serviceModel,
    this.selectedServices,
    this.phoneNumber,
    required this.currency,
  });

  @override
  String toString() {
    return 'AppointmentModel('
        'id: $id, '
        'userId: $userId, '
        'barberId: $barberId, '
        'price: $price, '
        'date: $date, '
        'time: $time, '
        'status: $status, '
        'services: $selectedServices, '
        'phone: $phoneNumber, '
        'currency: $currency'
        ')';
  }

  // Convert to JSON (for Firebase)
  Map<String, dynamic> toJson() {
    return {
      'orderBy': orderBy,
      'userId': userId,
      'barberId': barberId,
      'id': id,
      'price': price,
      'date': date.toIso8601String(),
      'time': time,
      'status': status,
      'note': note,
      'serviceId': serviceId,
      'timestamp': timestamp,
      'selectedServices': selectedServices,
      'phoneNumber': phoneNumber,
      "currency": currency,
    };
  }

  // Create from Firebase document
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      userId: json['userId'],
      orderBy: json['orderBy'],
      id: json['id'],
      barberId: json['barberId'],
      price: json['price'].toDouble(),
      date: DateTime.parse(json['date']),
      time: json['time'],
      status: json['status'],
      note: json['note'],
      serviceId: json['serviceId'],
      timestamp: json['timestamp'],

      selectedServices: json['selectedServices'] != null
          ? List<String>.from(json['selectedServices'])
          : null,
      phoneNumber: json['phoneNumber'],
      currency: json['currency'],
    );
  }
}
