import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glow_and_go/widgets/cus_buttom.dart';

import '../bottom/bottom_bar.dart';

class ReminderPage extends StatefulWidget {
  // final DateTime appointmentTime;

  const ReminderPage({super.key});

  // const ReminderPage({super.key, required this.appointmentTime});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  bool oneDayBefore = true;
  bool oneHourBefore = true;

  // void scheduleReminder(Duration offset, String message) {
  //   final scheduledTime = widget.appointmentTime.subtract(offset);

  //   flutterLocalNotificationsPlugin.zonedSchedule(
  //     scheduledTime.hashCode, // unique ID
  //     'Salon Appointment Reminder',
  //     message,
  //     tz.TZDateTime.from(scheduledTime, tz.local),
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'salon_reminder',
  //         'Salon Reminder',
  //         importance: Importance.high,
  //         priority: Priority.high,
  //       ),
  //     ),
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     androidAllowWhileIdle: true,
  //   );
  // }

  // void onConfirm() {
  //   if (oneHourBefore) {
  //     scheduleReminder(
  //         const Duration(minutes: 60), "Your appointment is in 1 hour!");
  //   }
  //   if (oneDayBefore) {
  //     scheduleReminder(
  //         const Duration(days: 1), "You have a salon appointment tomorrow!");
  //   }

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("Reminders set successfully!")),
  //   );
  //   Navigator.pop(context); // or move to home screen
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: CusButtom(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (context) => const BottomBar()),
              (_) => false,
            );
          },
          text: "Add Reminders",
        ),
      ),
      appBar: AppBar(
        title: const Text("Set Appointment Reminders"),
      ),
      body: Column(
        children: [
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/profile_pic.png"),
                  radius: 60,
                )
              ],
            ),
          ),
          Expanded(
              child: Column(
            children: [
              CheckboxListTile(
                value: oneHourBefore,
                title: const Text("Reminder 60 minutes before"),
                onChanged: (val) => setState(() => oneHourBefore = val!),
              ),
              CheckboxListTile(
                value: oneDayBefore,
                title: const Text("Reminder 1 day before"),
                onChanged: (val) => setState(() => oneDayBefore = val!),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
