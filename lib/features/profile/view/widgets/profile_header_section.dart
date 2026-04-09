import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/storage/cache_helper.dart';
import 'package:safqaseller/core/storage/cache_keys.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/profile/view/edit_account_view.dart';
import 'package:safqaseller/features/profile/view_model/profile_view_model.dart';
import 'package:safqaseller/features/subscription/view/subscription_view.dart';
import 'package:safqaseller/generated/l10n.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key, this.logoBytes});

  final Uint8List? logoBytes;

  @override
  Widget build(BuildContext context) {
    final cacheHelper = getIt<CacheHelper>();
    final activePlanLabel = _planLabel(context, _readActivePlanId(cacheHelper));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAvatar(),
                  if (activePlanLabel != null) ...[
                    SizedBox(height: 12.h),
                    _PlanBadge(
                      label: '${S.of(context).kActivePlan}: $activePlanLabel',
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionButton(
                label: S.of(context).kUpgrade,
                backgroundColor: AppColors.secondaryColor,
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    SubscriptionView.routeName,
                  );
                  if (!context.mounted) return;
                  context.read<ProfileViewModel>().loadFromCache();
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
        ],
      ),
    );
  }

  String? _readActivePlanId(CacheHelper cacheHelper) {
    final currentUserId = cacheHelper
        .getData(key: CacheKeys.userId)
        ?.toString();
    final planUserId = cacheHelper
        .getData(key: CacheKeys.activePlanUserId)
        ?.toString();

    if (currentUserId == null ||
        currentUserId.isEmpty ||
        planUserId == null ||
        planUserId.isEmpty ||
        currentUserId != planUserId) {
      return null;
    }

    return cacheHelper.getData(key: CacheKeys.activePlan)?.toString();
  }

  String? _planLabel(BuildContext context, String? activePlan) {
    switch (activePlan) {
      case '1':
        return S.of(context).kBasic;
      case '2':
        return S.of(context).kPremium;
      case '3':
        return S.of(context).kElite;
      default:
        return null;
    }
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
        width: 88.w,
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
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _PlanBadge extends StatelessWidget {
  const _PlanBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 170.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Text(
        label,
        style: TextStyles.semiBold13(
          context,
        ).copyWith(color: AppColors.primaryColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}
