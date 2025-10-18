import 'package:flutter/material.dart';
import 'package:glow_and_go/style/app_color.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeaderImage(),
          const SizedBox(height: 20),
          TabBar(
            controller: _tabController,
            labelColor: AppColor().kp,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColor().kp,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: "Unread"),
              Tab(text: "Archived"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUpcomingNotifications(),
                _buildPastNotifications(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/image4.webp"),
        ),
      ),
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
    );
  }

  Widget _buildUpcomingNotifications() {
    return const Center(child: Text("Unread Notifications"));
  }

  Widget _buildPastNotifications() {
    return const Center(child: Text("Archived Notifications"));
  }
}
