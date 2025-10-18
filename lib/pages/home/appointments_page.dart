import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:glow_and_go/models/appointment_model.dart';
import 'package:glow_and_go/models/barber_model.dart';
import 'package:glow_and_go/models/service_model.dart';
import 'package:glow_and_go/pages/home/booking_detail_page.dart';
import 'package:glow_and_go/service/appointment_service.dart';
import 'package:glow_and_go/service/barber_service.dart';
import 'package:glow_and_go/style/app_color.dart';
import 'package:provider/provider.dart';

import '../../config/app_config.dart';
import '../../models/salon_model.dart';
import '../../provider/salon_provider.dart';
import '../../widgets/cus_cached_bg.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AppointmentService _appointmentService = AppointmentService();

  List<AppointmentModel> _upcomingAppointments = [];
  List<AppointmentModel> _pastAppointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    List<AppointmentModel> upcoming = await _appointmentService
        .getUpcomingAppointments(userId);
    List<AppointmentModel> past = await _appointmentService.getPastAppointments(
      userId,
    );

    // Fetch barber and service details for each appointment
    for (var appointment in [...upcoming, ...past]) {
      appointment.barberModel = await BarberService().getBarberById(
        AppConfig.salonId,
        appointment.barberId,
      );

      appointment.serviceModel = await BarberService().getServiceById(
        AppConfig.salonId,

        appointment.serviceId,
      );
    }

    setState(() {
      _upcomingAppointments = upcoming;
      _pastAppointments = past;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SalonProvider>(
        builder: (context, provider, child) {
          final salon = provider.salon;
          if (salon == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _buildHeaderImage(salon),
              const SizedBox(height: 20),
              TabBar(
                controller: _tabController,
                labelColor: AppColor().kp,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColor().kp,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: "Upcoming"),
                  Tab(text: "Past"),
                ],
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildAppointmentList(_upcomingAppointments),
                          _buildAppointmentList(_pastAppointments),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderImage(Salon salon) {
    return SizedBox(
      height: 300,
      child: CusCachedBg(
        imageUrl: salon.termBg,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                const Color(0xff141118).withOpacity(1.0),
                const Color(0xff141118).withOpacity(0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentList(List<AppointmentModel> appointments) {
    print(appointments);
    if (appointments.isEmpty) {
      return const Center(child: Text("No Appointments"));
    }

    return ListView.builder(
      itemCount: appointments.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        var appointment = appointments[index];

        if (appointment.barberModel == null ||
            appointment.serviceModel == null) {
          return const SizedBox(); // Skip rendering if data is missing
        }

        return AppointmentCard(
          appointmentModel: appointment,
          barberModel: appointment.barberModel!,
          serviceModel: appointment.serviceModel!,
        );
      },
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointmentModel;
  final BarberModel barberModel;
  final ServiceModel serviceModel;

  const AppointmentCard({
    super.key,
    required this.appointmentModel,
    required this.barberModel,
    required this.serviceModel,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => BookingDetailScreen(
              appointmentModel: appointmentModel,
              barberModel: barberModel,
              serviceModel: serviceModel,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 2,
              height: 60,
              color: _getStatusColor(appointmentModel.status),
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            _buildDateTimeBox(),
            const VerticalDivider(color: Colors.white),
            Expanded(child: _buildDetails()),
          ],
        ),
      ),
    );
  }

  String formatTime(String time) {
    return time.split('-')[0].trim();
  }

  String formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, y').format(date);
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
  //     case 'canceled':
  //       return Colors.red;
  //     case 'accepted':
  //       return Colors.green;
  //     case 'pending':
  //     default:
  //       return Colors.yellow;
  //   }
  // }

  Widget _buildDateTimeBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          Text(
            DateFormat.MMMM().format(appointmentModel.date), // Displays "March"
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            appointmentModel.date.day.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            formatTime(appointmentModel.time),
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          serviceModel.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          barberModel.name,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          formatDate(appointmentModel.date),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
