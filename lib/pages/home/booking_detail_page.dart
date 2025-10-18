import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:glow_and_go/models/appointment_model.dart';
import 'package:glow_and_go/models/barber_model.dart';
import 'package:glow_and_go/models/service_model.dart';
import 'package:glow_and_go/service/appointment_service.dart';
import 'package:glow_and_go/widgets/catch_profile_image.dart';
import 'package:provider/provider.dart';

import '../../config/app_config.dart';
import '../../provider/salon_provider.dart';

class BookingDetailScreen extends StatelessWidget {
  final AppointmentModel appointmentModel;
  final BarberModel barberModel;
  final ServiceModel serviceModel;

  const BookingDetailScreen({
    super.key,
    required this.appointmentModel,
    required this.barberModel,
    required this.serviceModel,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SalonProvider>(
      builder: (context, provider, child) {
        final salon = provider.salon;
        if (salon == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          bottomNavigationBar:
              appointmentModel.status.toLowerCase() == 'pending'
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await AppointmentService()
                              .cancelAppointment(
                                AppConfig.salonId,

                                appointmentModel.id,
                                context,
                              )
                              .then((v) {
                                Navigator.of(context).pop();
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                )
              : null,
          backgroundColor: Colors.black,
          body: Column(
            children: [
              // Background Image with Overlay
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/image1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  padding: const EdgeInsets.only(top: 40),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [BackButton()],
                  ),
                ),
              ),

              // Main Content
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Confirmed Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(appointmentModel.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        appointmentModel.status[0].toUpperCase() +
                            appointmentModel.status.substring(1).toLowerCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Time and Date
                    Text(
                      appointmentModel.time,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      DateFormat(
                        'EEEE, MMMM d, y',
                      ).format(appointmentModel.date),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      appointmentModel.note!,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                    const Divider(color: Colors.white24, thickness: 1),
                    const SizedBox(height: 10),

                    // Service Details
                    Row(
                      children: [
                        CatchProfileImage(image: serviceModel.image),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              serviceModel.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              barberModel.name,
                              style: const TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  color: Colors.white54,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${serviceModel.duration} min',
                                  style: const TextStyle(color: Colors.white54),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  Icons.price_check,
                                  color: Colors.white54,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${salon.currency} ${serviceModel.price}',
                                  style: const TextStyle(color: Colors.white54),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Cancel Button
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'canceled':
        return Colors.red;
      case 'accepted':
        return Colors.green;
      case 'completed':
        return Colors.blue; // ✅ completed ke liye
      case 'absent':
        return Colors.orange; // ✅ notcome ke liye
      case 'pending':
      default:
        return Colors.yellow;
    }
  }

  // Color _getStatusColor(String status) {
  //   switch (status.toLowerCase()) {
  //     case 'cancelled':
  //       return Colors.red;
  //     case 'confirmed':
  //       return Colors.green;
  //     case 'pending':
  //     default:
  //       return Colors.yellow;
  //   }
  // }
}
