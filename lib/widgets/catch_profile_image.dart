import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CatchProfileImage extends StatelessWidget {
  final String? image;
  final double radius;

  const CatchProfileImage({
    super.key,
    required this.image,
    this.radius = 20.0,
  });

  bool _isValidImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    return url.startsWith('http'); // You can make this more robust if needed
  }

  @override
  Widget build(BuildContext context) {
    final showImage = _isValidImageUrl(image);

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey,
      child: showImage
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: image!,
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
                  Icons.person,
                  color: Colors.white,
                  size: radius,
                ),
              ),
            )
          : Icon(
              Icons.person,
              color: Colors.white,
              size: radius,
            ),
    );
  }
}
