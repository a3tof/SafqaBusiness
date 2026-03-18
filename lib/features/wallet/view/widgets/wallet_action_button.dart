import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';

/// Circular action button (Deposit / Withdrawal) used on the wallet screen.
/// Design: 50×50 filled circle + icon + two-line label below.
class WalletActionButton extends StatelessWidget {
  const WalletActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// true → primary filled circle (Deposit); false → light outlined (Withdrawal)
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled
                  ? AppColors.primaryColor
                  : AppColors.secondaryColor,
            ),
            child: Icon(
              icon,
              color: filled ? Colors.white : AppColors.primaryColor,
              size: 26.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyles.medium14(context)
                .copyWith(color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }
}
