import 'package:flutter/material.dart';
import '../services/config_manager.dart';

class PhotoCard extends StatelessWidget {
  final String imagePath;
  final double borderWidth;

  const PhotoCard({super.key, required this.imagePath, this.borderWidth = 6});

  @override
  Widget build(BuildContext context) {
    final manager = AppConfigManager.instance;
    final primary = manager.primaryColor;

    return Container(
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: primary.withOpacity(0.12), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20 - borderWidth),
        child: AspectRatio(
          aspectRatio: 4 / 5,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey.shade100,
              alignment: Alignment.center,
              child: Icon(Icons.favorite_border_sharp, color: primary, size: 40),
            ),
          ),
        ),
      ),
    );
  }
}
