import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CusCatchImage extends StatelessWidget {
  final String? profileImage;
  final double radius;

  const CusCatchImage({
    super.key,
    required this.profileImage,
    this.radius = 20.0,
  });

  bool _isValidImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    return url.startsWith('http'); // You can make this more robust if needed
  }

  @override
  Widget build(BuildContext context) {
    final showImage = _isValidImageUrl(profileImage);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(color: Colors.grey.shade800),
        child: showImage
            ? CachedNetworkImage(
                imageUrl: profileImage!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white70,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  color: Colors.white,
                  size: radius,
                ),
              )
            : Icon(
                Icons.error,
                color: Colors.white,
                size: radius,
              ),
      ),
    );
  }
}
