import 'package:flutter/material.dart';
import '../dashboard/colors.dart';
import '../core/constants.dart';

class PhotoCard extends StatelessWidget {
  final String imagePath;
  final double borderWidth;

  const PhotoCard({super.key, required this.imagePath, this.borderWidth = 6});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(color: AppColorsData.shadow, blurRadius: 24, offset: const Offset(0, 12)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium - borderWidth),
        child: AspectRatio(
          aspectRatio: 4 / 5,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: const Icon(Icons.favorite_border, color: Colors.grey, size: 40),
            ),
          ),
        ),
      ),
    );
  }
}
