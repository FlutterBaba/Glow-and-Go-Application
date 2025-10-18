import 'package:flutter/material.dart';
import 'package:glow_and_go/models/barber_model.dart';
import 'package:glow_and_go/pages/home/detail_page.dart';
import 'package:glow_and_go/service/barber_service.dart';
import 'package:provider/provider.dart';
import '../../models/salon_model.dart';
import '../../provider/salon_provider.dart';
import '../../style/text_style.dart';
import '../../widgets/cus_cached_bg.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
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
                _buildEmployeeSection(context),
                const SizedBox(height: 40),
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
        imageUrl: salon.serviceBg,
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

  Widget _buildEmployeeSection(BuildContext context) {
    return FutureBuilder<List<BarberModel>>(
      future: BarberService().getBarbers("salonId_yaqoob"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No barbers available"));
        }

        List<BarberModel> barbers = snapshot.data!;

        return Column(
          children: [
            Text("Choose Employee", style: h4Bold),
            Divider(color: Colors.grey.withOpacity(0.3)),
            ...barbers.map((barber) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailPage(barberModel: barber),
                    ),
                  );
                },
                leading: CircleAvatar(
                  backgroundImage: AssetImage(barber.profileImage),
                  backgroundColor: Colors.grey.withOpacity(0.3),
                ),
                title: Text(
                  barber.name,
                  style: p1Regular.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  barber.id == ""
                      ? "Offers the largest slots choice"
                      : "${barber.experience} years experience",
                  style: p1Regular.copyWith(fontSize: 10),
                ),
                trailing: const Icon(Icons.arrow_forward_rounded),
              );
            }),
          ],
        );
      },
    );
  }
}
