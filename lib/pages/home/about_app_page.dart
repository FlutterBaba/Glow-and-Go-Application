import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ Add this
import '../../models/salon_model.dart';
import '../../style/app_color.dart';
import '../../style/text_style.dart';
import '../../widgets/cus_cached_bg.dart';

class AboutAppPage extends StatelessWidget {
  final Salon salon;

  const AboutAppPage({super.key, required this.salon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              _buildHeaderImage(salon),
              Positioned(
                top: 40,
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
          Expanded(child: _buildContact()),
        ],
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

  Widget _buildContactIcon(String text, String socialName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            socialName,
            style: p1Regular.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColor().kdark3,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: p1Regular.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue, // ✅ Clickable look
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContact() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "About Application",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 10),

          // Email
          _buildContactIcon("lazarmilosevic2212@gmail.com", "Email", () {
            _launchEmail("lazarmilosevic2212@gmail.com");
          }),

          const SizedBox(height: 20),

          // WhatsApp
          _buildContactIcon("381649331266", "WhatsApp", () {
            _launchWhatsApp("381649331266");
          }),

          const SizedBox(height: 30),

          // Business Message
          Text(
            "Do you want digitalization of logistics for your business? Get in touch with us!",
            textAlign: TextAlign.center,
            style: p1Regular.copyWith(color: AppColor().kdark3),
          ),
        ],
      ),
    );
  }
  // 'lazar@hogostudios.com',

  // // ✅ Launch Email

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'Business Inquiry'},
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  // ✅ Launch WhatsApp
  static Future<void> _launchWhatsApp(String phone) async {
    final Uri whatsappUri = Uri.parse(
      "https://wa.me/$phone?text=Hello, I am interested in your services.",
    );
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $whatsappUri';
    }
  }
}
