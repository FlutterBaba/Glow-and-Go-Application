import 'package:flutter/material.dart';
import 'package:glow_and_go/pages/home/home_page.dart';
import 'package:glow_and_go/style/app_color.dart';
import '../home/appointments_page.dart';
import '../home/services_page.dart';
import '../home/settings_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ServicesPage(),
    AppointmentsPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return; // prevent unnecessary rebuild
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColor().kp,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_cut_outlined),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range_outlined),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
