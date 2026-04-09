import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/profile/view/edit_account_view.dart';
import 'package:safqaseller/features/profile/view_model/profile_view_model.dart';
import 'package:safqaseller/features/subscription/view/subscription_view.dart';
import 'package:safqaseller/generated/l10n.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key, this.logoBytes});

  /// Decoded logo bytes from GET seller/business-account.
  /// Displays a store icon placeholder when null.
  final Uint8List? logoBytes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          // ── Avatar with verified badge ──
          _buildAvatar(),
          SizedBox(width: 16.w),
          // ── Upgrade & Edit buttons ──
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionButton(
                label: S.of(context).kUpgrade,
                backgroundColor: AppColors.secondaryColor,
                onTap: () {
                  Navigator.pushNamed(context, SubscriptionView.routeName);
                },
              ),
              SizedBox(height: 8.h),
              _ActionButton(
                label: S.of(context).kEdit,
                backgroundColor: const Color(0xFFF5F5F5),
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    EditAccountView.routeName,
                    arguments: context.read<ProfileViewModel>().state,
                  );
                  if (!context.mounted) return;
                  if (result is String && result.isNotEmpty) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(result)));
                    context.read<ProfileViewModel>().fetchProfile();
                  }
                },
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 90.w,
          height: 90.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.secondaryColor,
            border: Border.all(color: const Color(0xFFCCDDEE), width: 2),
          ),
          child: ClipOval(
            child: logoBytes != null
                ? Image.memory(logoBytes!, fit: BoxFit.cover)
                : Icon(
                    Icons.store_rounded,
                    color: AppColors.primaryColor,
                    size: 50.sp,
                  ),
          ),
        ),
        // Verified badge
        Positioned(
          bottom: 2.h,
          right: 2.w,
          child: Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(Icons.check, color: Colors.white, size: 14.sp),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.backgroundColor,
    required this.onTap,
  });

  final String label;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.semiBold13(
              context,
            ).copyWith(color: AppColors.primaryColor),
          ),
        ),
      ),
    );
  }
}
