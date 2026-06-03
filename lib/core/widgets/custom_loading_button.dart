import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';

class CustomLoadingButton extends StatelessWidget {
  const CustomLoadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    return SizedBox(
      width: double.infinity,
      height: isTabletOrUp ? 54.0 : 54.sp,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.rSp(context)),
          ),
        ),
        onPressed: () {},
        child: Center(
          child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}
