// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:glow_and_go/models/barber_model.dart';
// import 'package:glow_and_go/models/service_model.dart';

// class BarberService {
//   Future<List<BarberModel>> getBarbers() async {
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//     QuerySnapshot snapshot = await firestore.collection('barbers').get();

//     return snapshot.docs.map((doc) => BarberModel.fromFirestore(doc)).toList();
//   }

//   Future<List<ServiceModel>> getAllServices() async {
//     QuerySnapshot querySnapshot =
//         await FirebaseFirestore.instance.collection('services').get();

//     return querySnapshot.docs
//         .map((doc) => ServiceModel.fromFirestore(doc))
//         .toList();
//   }

//   Future<BarberModel?> getBarberForService(String barberId) async {
//     DocumentSnapshot barberDoc = await FirebaseFirestore.instance
//         .collection('barbers')
//         .doc(barberId)
//         .get();

//     if (barberDoc.exists) {
//       return BarberModel.fromFirestore(barberDoc);
//     } else {
//       return null;
//     }
//   }

//   Future<List<ServiceModel>> getServicesByBarberId(String barberId) async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('services')
//         .where('barberId', isEqualTo: barberId) // Filter by barber ID
//         .get();

//     return querySnapshot.docs
//         .map((doc) => ServiceModel.fromFirestore(doc))
//         .toList();
//   }

//   Future<ServiceModel?> getServiceById(String serviceId) async {
//     DocumentSnapshot serviceDoc = await FirebaseFirestore.instance
//         .collection('services')
//         .doc(serviceId)
//         .get();

//     if (serviceDoc.exists) {
//       return ServiceModel.fromFirestore(serviceDoc);
//     } else {

//       return null;
//     }
//   }

// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glow_and_go/models/barber_model.dart';
import 'package:glow_and_go/models/service_model.dart';

class BarberService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Get all barbers of a specific salon
  Future<List<BarberModel>> getBarbers(String salonId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('salons')
        .doc(salonId)
        .collection('barbers')
        .get();

    return snapshot.docs.map((doc) => BarberModel.fromFirestore(doc)).toList();
  }

  /// ✅ Get all services of a salon
  Future<List<ServiceModel>> getAllServices(String salonId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('salons')
        .doc(salonId)
        .collection('services')
        .get();

    return querySnapshot.docs
        .map((doc) => ServiceModel.fromFirestore(doc))
        .toList();
  }

  /// ✅ Get single barber by ID
  Future<BarberModel?> getBarberById(String salonId, String barberId) async {
    DocumentSnapshot barberDoc = await _firestore
        .collection('salons')
        .doc(salonId)
        .collection('barbers')
        .doc(barberId)
        .get();

    if (barberDoc.exists) {
      return BarberModel.fromFirestore(barberDoc);
    } else {
      return null;
    }
  }

  /// ✅ Get all services offered by a specific barber
  Future<List<ServiceModel>> getServicesByBarberId(
    String salonId,
    String barberId,
  ) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('salons')
        .doc(salonId)
        .collection('services')
        .where('barberId', isEqualTo: barberId)
        .get();

    return querySnapshot.docs
        .map((doc) => ServiceModel.fromFirestore(doc))
        .toList();
  }

  /// ✅ Get service by ID
  Future<ServiceModel?> getServiceById(String salonId, String serviceId) async {
    DocumentSnapshot serviceDoc = await _firestore
        .collection('salons')
        .doc(salonId)
        .collection('services')
        .doc(serviceId)
        .get();

    if (serviceDoc.exists) {
      return ServiceModel.fromFirestore(serviceDoc);
    } else {
      return null;
    }
  }
}
