import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CusCachedBg extends StatelessWidget {
  final String? imageUrl;
  final Widget? child;

  const CusCachedBg({
    super.key,
    required this.imageUrl,
    this.child,
  });

  bool _isValidImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    return url.startsWith('http');
  }

  @override
  Widget build(BuildContext context) {
    final showImage = _isValidImageUrl(imageUrl);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
      ),
      child: showImage
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white70,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade700,
                child: const Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                child: child,
              ),
            )
          : Container(
              color: Colors.grey.shade700,
              child: const Center(
                child: Icon(Icons.error, color: Colors.white, size: 40),
              ),
            ),
    );
  }
}
