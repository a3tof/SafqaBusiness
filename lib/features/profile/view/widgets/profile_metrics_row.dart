import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';

class ProfileMetricsRow extends StatelessWidget {
  const ProfileMetricsRow({
    super.key,
    required this.rating,
    required this.followersCount,
    required this.auctionsCount,
  });

  final String rating;
  final String followersCount;
  final String auctionsCount;

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTabletOrUp ? 16.0 : 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _MetricItem(
            icon: Icons.star_outline,
            iconColor: const Color(0xFFFFC107),
            value: rating,
          ),
          SizedBox(width: isTabletOrUp ? 32.0 : 32.w),
          _MetricItem(
            icon: Icons.groups_outlined,
            iconColor: Theme.of(context).colorScheme.primary,
            value: followersCount,
          ),
          SizedBox(width: isTabletOrUp ? 32.0 : 32.w),
          _MetricItem(
            icon: Icons.gavel_outlined,
            iconColor: Theme.of(context).colorScheme.primary,
            value: auctionsCount,
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.icon,
    required this.iconColor,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 22.rSp(context)),
        SizedBox(width: isTabletOrUp ? 6.0 : 6.w),
        Text(
          value,
          style: TextStyles.semiBold14(
            context,
          ).copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }
}
