import 'package:flutter/material.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';

/// Circular action button (Deposit / Withdrawal) used on the wallet screen.
/// Design: 50×50 filled circle + icon + two-line label below.
class WalletActionButton extends StatelessWidget {
  const WalletActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    final displayLabel = label.replaceAll(r'\n', '\n');
    final circleColor = backgroundColor ?? Theme.of(context).colorScheme.secondary;
    final foregroundColor = iconColor ?? Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: (isTabletOrUp ? 50.0 : 50.w),
            height: (isTabletOrUp ? 50.0 : 50.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleColor,
            ),
            child: Icon(
              icon,
              color: foregroundColor,
              size: 24.rSp(context),
            ),
          ),
          SizedBox(height: (isTabletOrUp ? 8.0 : 8.h)),
          SizedBox(
            width: (isTabletOrUp ? 86.0 : 86.w),
            child: Text(
              displayLabel,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyles.medium14(context)
                  .copyWith(color: Theme.of(context).colorScheme.primary, height: 1.15),
            ),
          ),
        ],
      ),
    );
  }
}
