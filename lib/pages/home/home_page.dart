import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../models/salon_model.dart';
import '../../provider/salon_provider.dart';
import '../../style/text_style.dart';
import '../../widgets/cus_cached_bg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                _buildAboutSection(salon),
                const SizedBox(height: 30),
                // _buildContactRow(salon),
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
        imageUrl: salon.homeBg,
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

  Widget _buildAboutSection(Salon salon) {
    return Column(
      children: [
        Text("About us", style: p1Regular),
        Text(salon.title, style: h4Bold),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            salon.about,
            textAlign: TextAlign.center,
            style: p1Regular.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Locations",
          style: p1Regular.copyWith(fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            salon.address,
            textAlign: TextAlign.center,
            style: p1Regular.copyWith(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
