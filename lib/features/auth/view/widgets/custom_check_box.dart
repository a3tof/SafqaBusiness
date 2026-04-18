import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safqaseller/core/utils/app_images.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    required this.isChecked,
    required this.onChecked,
  });

  final bool isChecked;
  final ValueChanged<bool> onChecked;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChecked(!isChecked);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        height: 24.sp,
        width: 24.sp,
        decoration: ShapeDecoration(
          color: isChecked ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.50,
              color: isChecked ? Colors.transparent : Theme.of(context).dividerColor,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: isChecked
            ? Padding(
                padding: EdgeInsets.all(2.sp),
                child: SvgPicture.asset(Assets.imagesCheck),
              )
            : SizedBox(),
      ),
    );
  }
}
