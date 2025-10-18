import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glow_and_go/models/barber_model.dart';
import 'package:glow_and_go/models/service_model.dart';
import 'package:glow_and_go/service/barber_service.dart';
import 'package:glow_and_go/widgets/cus_buttom.dart';
import 'package:glow_and_go/widgets/cus_catch_image.dart';
import '../../config/app_config.dart';
import '../../style/text_style.dart';
import '../../utils/toast_helper.dart';
import 'service_details.dart';

class DetailPage extends StatelessWidget {
  final BarberModel barberModel;
  const DetailPage({super.key, required this.barberModel});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              _buildHeaderImage(),
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
          Expanded(
            child: Column(
              children: [
                Text("Services & Price List", style: h4Bold),
                Divider(color: Colors.grey.withOpacity(0.3)),
                Expanded(
                  child: FutureBuilder<List<ServiceModel>>(
                    future: barberModel.id == ""
                        ? BarberService().getAllServices(AppConfig.salonId)
                        : BarberService().getServicesByBarberId(
                            AppConfig.salonId,

                            barberModel.id,
                          ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text("No services available"),
                        );
                      }

                      List<ServiceModel> serviceList = snapshot.data!;

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: serviceList.length,
                        itemBuilder: (context, index) {
                          return ServiceCard(
                            serviceModel: serviceList[index],
                            onPressed: () {
                              if (currentUser == null ||
                                  currentUser.isAnonymous) {
                                ToastHelper.show("Please login first");
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ServiceDetails(
                                      serviceModel: serviceList[index],
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
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
          image: AssetImage("assets/images/image1.jpg"),
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
}

class ServiceCard extends StatelessWidget {
  final ServiceModel serviceModel;
  final void Function()? onPressed;

  const ServiceCard({
    super.key,
    required this.serviceModel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          CusCatchImage(profileImage: serviceModel.image),
          // Container(
          //   height: 90,
          //   width: 90,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(12),
          //     image: DecorationImage(
          //       fit: BoxFit.cover,
          //       image: CachedNetworkImageProvider(serviceModel.image),
          //     ),
          //   ),
          // ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                serviceModel.name,
                style: p1Regular.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                "Duration: ${serviceModel.duration}",
                style: p1Regular.copyWith(fontSize: 12),
              ),
              Text(
                "Fixed price: ${serviceModel.price}",
                style: p1Regular.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width / 1.8,
                child: CusButtom(
                  text: "Reserve",
                  color: Colors.white,
                  textColor: Colors.black,
                  onPressed: onPressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
