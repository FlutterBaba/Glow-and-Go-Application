import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String id;
  final String image;
  final String name;
  final String barberId;
  final String duration;
  final int price;

  ServiceModel({
    required this.id,
    required this.image,
    required this.name,
    required this.barberId,
    required this.duration,
    required this.price,
  });

  // Convert Firestore document to ServiceModel object
  factory ServiceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ServiceModel(
      id: doc.id,
      barberId: data['barberId'] ?? '',
      image: data['image'] ?? '',
      name: data['name'] ?? '',
      duration: data['duration'] ?? '',
      price: data['price'] ?? 0,
    );
  }

  // Convert ServiceModel object to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'duration': duration,
      'price': price,
    };
  }
}
