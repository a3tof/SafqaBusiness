import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.image,
    required this.title,
    required this.onPressed,
  });

  final String image;
  final String title;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.sp,
      child: TextButton(
        style: TextButton.styleFrom(
          side: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.sp),
          ),
        ),
        onPressed: onPressed,
        child: ListTile(
          visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity),
          leading: SvgPicture.asset(image, width: 24.sp, height: 24.sp),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyles.semiBold16(context),
          ),
        ),
      ),
    );
  }
}
