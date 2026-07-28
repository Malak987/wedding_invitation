import 'package:flutter/material.dart';
import '../dashboard/images.dart';
import '../dashboard/strings.dart';
import '../dashboard/colors.dart';
import '../core/responsive.dart';
import '../core/constants.dart';
import '../widgets/section_title.dart';
import '../widgets/gallery_image.dart';
import '../animations/scale_in.dart';

class GallerySection extends StatelessWidget {
  const GallerySection({super.key});

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = Responsive.value<int>(context, mobile: 2, tablet: 3, desktop: 3);

    return Container(
      color: AppColorsData.background,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: Responsive.value(context,
            mobile: AppConstants.sectionSpacingMobile, desktop: AppConstants.sectionSpacing),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
          child: Column(
            children: [
              const SectionTitle(title: AppStrings.galleryTitle),
              const SizedBox(height: 36),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: AppImages.gallery.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  return ScaleIn(
                    delay: Duration(milliseconds: 80 * (index % 6)),
                    child: GalleryImage(imagePath: AppImages.gallery[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
