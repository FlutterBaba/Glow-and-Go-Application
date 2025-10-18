import 'package:cloud_firestore/cloud_firestore.dart';

class BarberModel {
  final String id;
  final String name;
  final String profileImage;
  final int experience;
  final List<AvailableSlot> availableSlots;
  final Timestamp createdAt;
  final String createdBy; // ✅ New field

  BarberModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.experience,
    required this.createdBy, // ✅ Include in constructor

    required this.availableSlots,
    required this.createdAt,
  });

  factory BarberModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    List<AvailableSlot> slots = [];
    if (data['availableSlots'] != null) {
      slots = List<Map<String, dynamic>>.from(data['availableSlots'])
          .map((slotData) => AvailableSlot.fromMap(slotData))
          .toList();
    }

    return BarberModel(
      id: doc.id,
      name: data['name'] ?? '',
      createdBy: data['createdBy'], // ✅ Parse from JSON

      profileImage: "assets/images/profile_pic.png", // Local image
      experience: data['experience'] ?? 0,
      availableSlots: slots,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profileImage': profileImage,
      'experience': experience,
      'availableSlots': availableSlots.map((slot) => slot.toMap()).toList(),
      'createdAt': createdAt,
    };
  }
}

class AvailableSlot {
  final String time;
  final bool isBooked;

  AvailableSlot({
    required this.time,
    required this.isBooked,
  });

  factory AvailableSlot.fromMap(Map<String, dynamic> map) {
    return AvailableSlot(
      time: map['time'] ?? '',
      isBooked: map['isBooked'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'isBooked': isBooked,
    };
  }
}
