import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glow_and_go/models/salon_model.dart';
import 'package:glow_and_go/pages/auth/auth_page.dart';
import 'package:glow_and_go/pages/home/setting/privacy_policy_screen.dart';
import 'package:glow_and_go/pages/home/setting/terms_conditions_page.dart';
import 'package:glow_and_go/service/auth_service.dart';
import '../../config/app_config.dart';
import '../../style/app_color.dart';
import '../../style/text_style.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/cus_cached_bg.dart';
import '../auth/delete_account_dialog.dart';

class MyAccountPage extends StatefulWidget {
  final Salon salon;

  const MyAccountPage({super.key, required this.salon});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              _buildHeaderImage(widget.salon),
              Positioned(
                top: 40, // Adjusted for safe area
                left: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          Expanded(child: _buildAccountSection(context)),
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

  Widget _buildAccountSection(BuildContext context) {
    return Column(
      children: [
        Text("My account", style: h4Bold),
        Divider(color: Colors.grey.withOpacity(0.3)),
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
            );
          },
          leading: const Icon(Icons.lock_outline),
          title: Text(
            "Privacy policy",
            style: p1Regular.copyWith(color: AppColor().kdark3),
          ),
          trailing: const Icon(Icons.arrow_forward_rounded),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TermsAndConditionsScreen(),
              ),
            );
          },
          leading: const Icon(Icons.lock_outline),
          title: Text(
            "Terms & Conditions",
            style: p1Regular.copyWith(color: AppColor().kdark3),
          ),
          trailing: const Icon(Icons.arrow_forward_rounded),
        ),
        // ListTile(
        //   onTap: () {
        //     Navigator.of(
        //       context,
        //     ).push(MaterialPageRoute(builder: (context) => AboutAppPage()));
        //   },
        //   leading: const Icon(Icons.info_outline),
        //   title: Text(
        //     "About application",
        //     style: p1Regular.copyWith(color: AppColor().kdark3),
        //   ),
        //   trailing: const Icon(Icons.arrow_forward_rounded),
        // ),
        ListTile(
          onTap: () {
            DeleteAccountDialog.show(
              context,
              salonId: AppConfig.salonId,

              email: FirebaseAuth.instance.currentUser?.email ?? "",
              onDelete: (dialogCtx, salonId, email, password) async {
                bool success = await AuthService().deleteAccount(
                  salonId,
                  email,
                  password,
                );

                if (success) {
                  ToastHelper.show("Account deleted successfully!");

                  // ✅ Close the dialog
                  Navigator.of(dialogCtx).pop();

                  // ✅ Sign out
                  await FirebaseAuth.instance.signOut();

                  // ✅ Clear all previous routes and go to AuthPage
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const AuthPage()),
                      (route) => false, // remove all previous
                    );
                  }
                }
              },
            );
          },
          leading: const Icon(Icons.delete_outline),
          title: Text(
            "Delete my account",
            style: p1Regular.copyWith(color: AppColor().kdark3),
          ),
          trailing: const Icon(Icons.arrow_forward_rounded),
        ),
      ],
    );
  }
}
