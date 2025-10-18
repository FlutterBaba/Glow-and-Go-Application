class Salon {
  final String salonId;
  final String name;
  final String ownerEmail;
  final String phone;
  final String address;
  final String title;
  final String about;
  final String homeBg;
  final String serviceBg;
  final String termBg;
  final String settingBg;
  final String currency;

  Salon({
    required this.salonId,
    required this.name,
    required this.ownerEmail,
    required this.phone,
    required this.address,
    required this.title,
    required this.about,
    required this.homeBg,
    required this.serviceBg,
    required this.termBg,
    required this.settingBg,
    required this.currency,
  });

  factory Salon.fromJson(Map<String, dynamic> json) {
    return Salon(
      salonId: json['salonId'] ?? '',
      name: json['name'] ?? '',
      ownerEmail: json['ownerEmail'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      title: json['title'] ?? '',
      about: json['about'] ?? '',
      homeBg: json['home_bg_image'] ?? '',
      serviceBg: json['services_bg_image'] ?? '',
      termBg: json['term_bg_image'] ?? '',
      settingBg: json['settings_bg_image'] ?? '',
      currency: json['currency'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'salonId': salonId,
      'name': name,
      'ownerEmail': ownerEmail,
      'phone': phone,
      'address': address,
      'title': title,
      'about': about,
      'home_bg_image': homeBg,
      'services_bg_image': serviceBg,
      'term_bg_image': termBg,
      'settings_bg_image': settingBg,
      'currency': currency,
    };
  }

  // 👇 This allows you to "update" fields immutably
  Salon copyWith({
    String? salonId,
    String? name,
    String? ownerEmail,
    String? phone,
    String? address,
    String? title,
    String? about,
    String? homeBg,
    String? serviceBg,
    String? termBg,
    String? settingBg,
    String? currency,
  }) {
    return Salon(
      salonId: salonId ?? this.salonId,
      name: name ?? this.name,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      title: title ?? this.title,
      about: about ?? this.about,
      homeBg: homeBg ?? this.homeBg,
      serviceBg: serviceBg ?? this.serviceBg,
      termBg: termBg ?? this.termBg,
      settingBg: settingBg ?? this.settingBg,
      currency: currency ?? this.currency,
    );
  }
}
