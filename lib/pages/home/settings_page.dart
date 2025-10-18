import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glow_and_go/pages/home/about_app_page.dart';
import 'package:glow_and_go/pages/home/my_account_page.dart';
import 'package:glow_and_go/service/auth_service.dart';
import 'package:glow_and_go/session_manager/user_session.dart';
import 'package:glow_and_go/style/app_color.dart';
import 'package:provider/provider.dart';
import '../../models/salon_model.dart';
import '../../provider/salon_provider.dart';
import '../../style/text_style.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/cus_cached_bg.dart';
import 'user_profile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
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

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeaderImage(salon),
                const SizedBox(height: 20),
                _buildSettingsSection(context, salon),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderImage(Salon salon) {
    return SizedBox(
      height: 400,
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

  Widget _buildSettingsSection(BuildContext context, Salon salon) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Column(
      children: [
        Text("Settings", style: h4Bold),
        Divider(color: Colors.grey.withOpacity(0.3)),
        ListTile(
          onTap: () {
            if (currentUser == null || currentUser.isAnonymous) {
              ToastHelper.show("Please login first");
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserProfile(salon: salon),
                ),
              );
            }
          },
          leading: const Icon(Icons.person_outline),
          title: Text(
            "User Profile",
            style: p1Regular.copyWith(color: AppColor().kdark3),
          ),
          trailing: const Icon(Icons.arrow_forward_rounded),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MyAccountPage(salon: salon),
              ),
            );
          },
          leading: const Icon(Icons.settings_outlined),
          title: Text(
            "My account",
            style: p1Regular.copyWith(color: AppColor().kdark3),
          ),
          trailing: const Icon(Icons.arrow_forward_rounded),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AboutAppPage(salon: salon),
              ),
            );
          },
          leading: const Icon(Icons.info_outline),
          title: Text(
            "About application",
            style: p1Regular.copyWith(color: AppColor().kdark3),
          ),
          trailing: const Icon(Icons.arrow_forward_rounded),
        ),
        ListTile(
          onTap: () {
            UserSession.clear();
            AuthService().logout(context);
          },
          leading: const Icon(Icons.exit_to_app_outlined),
          title: Text(
            "Sign out",
            style: p1Regular.copyWith(color: AppColor().kdark3),
          ),
          trailing: const Icon(Icons.arrow_forward_rounded),
        ),
      ],
    );
  }
}
