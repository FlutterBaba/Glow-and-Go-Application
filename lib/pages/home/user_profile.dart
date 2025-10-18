import 'package:flutter/material.dart';
import 'package:glow_and_go/session_manager/user_session.dart';
import '../../models/salon_model.dart';
import '../../models/user_model.dart';
import '../../style/text_style.dart';
import '../../widgets/cus_cached_bg.dart';

class UserProfile extends StatefulWidget {
  final Salon salon;
  const UserProfile({super.key, required this.salon});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final user = UserSession.currentUser;

    return Scaffold(
      body: user == null
          ? Center(child: Text("Something Want Wrong..."))
          : Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildHeaderImage(widget.salon),
                    Positioned(
                      top: 40,
                      left: 20,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 50,
                                backgroundImage: AssetImage(
                                  "assets/images/profile_pic.png",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(user.fullName, style: b1Bold),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: _buildSettingsSection(user),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeaderImage(Salon salon) {
    return SizedBox(
      height: 300,
      child: CusCachedBg(
        imageUrl: salon.settingBg,
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

  Widget _buildUserDetail(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(UserModel? user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Divider(color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 20),

          _buildUserDetail("Full Name", user!.fullName, Icons.person),
          _buildUserDetail("Email Address", user.email, Icons.email),
          _buildUserDetail("Phone Number", user.phoneNumber, Icons.phone),
        ],
      ),
    );
  }
}
