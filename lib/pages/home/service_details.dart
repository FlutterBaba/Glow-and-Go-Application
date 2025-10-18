// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:glow_and_go/models/barber_model.dart';
import 'package:glow_and_go/models/service_model.dart';
import 'package:glow_and_go/pages/home/check_out_page.dart';
import 'package:glow_and_go/pages/home/detail_page.dart';
import 'package:glow_and_go/service/barber_service.dart';
import 'package:glow_and_go/widgets/cus_buttom.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../config/app_config.dart';
import '../../provider/salon_provider.dart' show SalonProvider;
import '../../widgets/catch_profile_image.dart';

class ServiceDetails extends StatefulWidget {
  final ServiceModel serviceModel;

  const ServiceDetails({super.key, required this.serviceModel});

  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  DateTime selectedDate = DateTime.now();
  String? selectedTimeSlot;
  BarberModel? barberModel;
  List<ServiceModel> selectedServices = []; // List to hold selected services

  /// Finds the next available date with slots
  DateTime? getNextAvailableDate() {
    for (AvailableSlot slot in barberModel!.availableSlots) {
      DateTime slotDate = DateTime.parse(slot.time);
      if (!slot.isBooked && slotDate.isAfter(selectedDate)) {
        return slotDate;
      }
    }
    return null; // No future available date
  }

  void _loadBarberData() async {
    BarberModel? barber = await BarberService().getBarberById(
      AppConfig.salonId,

      widget.serviceModel.barberId,
    );

    setState(() {
      barberModel = barber;
    });
  }

  @override
  void initState() {
    _loadBarberData();
    super.initState();
  }

  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (barberModel == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Filter available slots for the selected date and that are not booked
    List<AvailableSlot> availableTimeSlots = barberModel!.availableSlots.where((
      slot,
    ) {
      DateTime slotDate = DateTime.parse(slot.time);
      return !slot.isBooked &&
          slotDate.year == selectedDate.year &&
          slotDate.month == selectedDate.month &&
          slotDate.day == selectedDate.day;
    }).toList();

    // Auto-select the first available time slot when a new day is selected
    if (availableTimeSlots.isNotEmpty && selectedTimeSlot == null) {
      selectedTimeSlot = availableTimeSlots.first.time;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Select Date & Time")),
      body: Consumer<SalonProvider>(
        builder: (context, provider, child) {
          final salon = provider.salon;
          if (salon == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const Text(
                  "Choose a Date",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 30)),
                  focusedDay: selectedDate,
                  calendarFormat: CalendarFormat.month,
                  availableCalendarFormats: const {
                    CalendarFormat.month: "Month",
                  },
                  selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                  enabledDayPredicate: (day) {
                    // Enable the day only if there's at least one **unbooked** slot on that day
                    return barberModel!.availableSlots.any((slot) {
                      final slotDate = DateTime.parse(slot.time);
                      return !slot.isBooked &&
                          slotDate.year == day.year &&
                          slotDate.month == day.month &&
                          slotDate.day == day.day;
                    });
                  },
                  onDaySelected: (selectedDay, _) {
                    setState(() {
                      selectedDate = selectedDay;
                      selectedTimeSlot = null; // Reset time slot
                    });
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final isEnabled = barberModel!.availableSlots.any((slot) {
                        final slotDate = DateTime.parse(slot.time);
                        return !slot.isBooked &&
                            slotDate.year == day.year &&
                            slotDate.month == day.month &&
                            slotDate.day == day.day;
                      });

                      return Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: isEnabled
                                ? Colors.white.withOpacity(0.9)
                                : Colors.white,
                          ),
                        ),
                      );
                    },
                    disabledBuilder: (context, day, focusedDay) {
                      return Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(color: Colors.grey.withOpacity(0.4)),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10),
                availableTimeSlots.isEmpty
                    ? Column(
                        children: [
                          const Center(
                            child: Text(
                              "No available time slots on selected day",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          getNextAvailableDate() != null
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedDate = getNextAvailableDate()!;
                                      selectedTimeSlot = null;
                                    });
                                  },
                                  child: Text(
                                    "Go to ${DateFormat.yMMMEd().format(getNextAvailableDate()!)}",
                                    style: const TextStyle(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      )
                    : Wrap(
                        spacing: 10,
                        children: availableTimeSlots.map((slot) {
                          final slotDateTime = DateTime.parse(slot.time);
                          return ChoiceChip(
                            label: Text(DateFormat.jm().format(slotDateTime)),
                            selected: selectedTimeSlot == slot.time,
                            onSelected: (selected) {
                              setState(() {
                                selectedTimeSlot = slot.time;
                              });
                            },
                          );
                        }).toList(),
                      ),
                const SizedBox(height: 10),
                const Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.serviceModel.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(
                            barberModel!.profileImage,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          barberModel!.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${salon.currency} ${widget.serviceModel.price}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            selectedTimeSlot != null
                                ? Text(
                                    "${DateFormat.jm().format(DateTime.parse(selectedTimeSlot!))} - ${DateFormat.jm().format(DateTime.parse(selectedTimeSlot!).add(const Duration(minutes: 30)))}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                    ),
                                  )
                                : const Text(
                                    "Unavailable",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: selectedServices
                          .map(
                            (service) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CatchProfileImage(
                                image: service.image,
                                // backgroundImage: NetworkImage(service.image),
                              ),
                              title: Text(service.name),
                              subtitle: Text(
                                "${salon.currency} ${service.price}",
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.add_circle_outline),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            // Navigate to Service Selection Page
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => ServiceSelectionPage(
                                  barberId: barberModel!.id,
                                  onServiceSelected: (ServiceModel service) {
                                    if (!selectedServices.any(
                                      (s) => s.id == service.id,
                                    )) {
                                      selectedServices.add(service);
                                    }
                                  },
                                  // onServiceSelected: (ServiceModel service) {
                                  //   setState(() {
                                  //     selectedServices.add(service);
                                  //   });
                                  // },
                                ),
                              ),
                            );
                          },
                          child: const Text("Add another service"),
                        ),
                      ],
                    ),

                    // Display total price
                    const SizedBox(height: 20),
                    TextField(
                      maxLines: 6,
                      controller: noteController,
                      decoration: InputDecoration(
                        hintText: "Leave note",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CusButtom(
                  onPressed: selectedTimeSlot == null
                      ? null
                      : () async {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => CheckOutPage(
                                barberModel: barberModel!,
                                noteController: noteController,
                                selectedDate: selectedDate,
                                serviceModel: widget.serviceModel,
                                selectedServices:
                                    selectedServices, // Pass selected services
                                time:
                                    "${DateFormat.jm().format(DateTime.parse(selectedTimeSlot!))} - ${DateFormat.jm().format(DateTime.parse(selectedTimeSlot!).add(const Duration(minutes: 30)))}",
                              ),
                            ),
                          );
                        },
                  text: "Continue",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ServiceSelectionPage extends StatelessWidget {
  final String barberId;
  final Function(ServiceModel) onServiceSelected;

  const ServiceSelectionPage({
    super.key,
    required this.onServiceSelected,
    required this.barberId,
  });

  Future<List<ServiceModel>> _getAvailableServices() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // fetch all services by barber
    final services = await BarberService().getServicesByBarberId(
      AppConfig.salonId,

      barberId,
    );

    // fetch user’s active appointments with this barber
    final bookedSnapshot = await FirebaseFirestore.instance
        .collection("salons")
        .doc(AppConfig.salonId)
        .collection("appointments")
        .where("userId", isEqualTo: userId)
        .where("barberId", isEqualTo: barberId)
        .where("status", whereIn: ["pending", "accepted"])
        .get();

    final bookedServiceIds = bookedSnapshot.docs
        .map((doc) => doc["serviceId"])
        .toSet();

    // filter out already booked services
    return services
        .where((service) => !bookedServiceIds.contains(service.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Service")),
      body: FutureBuilder<List<ServiceModel>>(
        future: _getAvailableServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No services available"));
          }
          List<ServiceModel> serviceList = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: serviceList.length,
            itemBuilder: (context, index) {
              return ServiceCard(
                serviceModel: serviceList[index],
                onPressed: () {
                  onServiceSelected(serviceList[index]);
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
    );
  }
}
