import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/profile/view/edit_account_view.dart';
import 'package:safqaseller/features/profile/view_model/profile_view_model.dart';
import 'package:safqaseller/features/subscription/view/subscription_view.dart';
import 'package:safqaseller/generated/l10n.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({
    super.key,
    this.logoBytes,
    this.activePlanId,
    this.verificationStatus,
  });

  final Uint8List? logoBytes;
  final String? activePlanId;
  final int? verificationStatus;

  @override
  Widget build(BuildContext context) {
    final activePlanLabel = _planLabel(context, activePlanId);

    final isTabletOrUp = Breakpoints.isTabletOrUp(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTabletOrUp ? 16.0 : 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAvatar(context),
                  if (activePlanLabel != null) ...[
                    SizedBox(height: isTabletOrUp ? 12.0 : 12.h),
                    _PlanBadge(
                      label: '${S.of(context).kActivePlan}: $activePlanLabel',
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(width: isTabletOrUp ? 16.0 : 16.w),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionButton(
                label: S.of(context).kUpgrade,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    SubscriptionView.routeName,
                  );
                  if (!context.mounted) return;
                  context.read<ProfileViewModel>().loadFromCache();
                },
              ),
              SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
              _ActionButton(
                label: S.of(context).kEdit,
                backgroundColor: Theme.of(context).colorScheme.surface,
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

  Widget _buildAvatar(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);

    return Stack(
      children: [
        Container(
          width: isTabletOrUp ? 90.0 : 90.w,
          height: isTabletOrUp ? 90.0 : 90.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.secondary,
            border: Border.all(color: const Color(0xFFCCDDEE), width: 2),
          ),
          child: ClipOval(
            child: logoBytes != null
                ? Image.memory(logoBytes!, fit: BoxFit.cover)
                : Icon(
                    Icons.store_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 50.rSp(context),
                  ),
          ),
        ),
        if (verificationStatus == 2)
          Positioned(
            bottom: isTabletOrUp ? 2.0 : 2.h,
            right: isTabletOrUp ? 2.0 : 2.w,
            child: Container(
              width: isTabletOrUp ? 24.0 : 24.w,
              height: isTabletOrUp ? 24.0 : 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 14.rSp(context),
              ),
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
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isTabletOrUp ? 88.0 : 88.w,
        padding: EdgeInsets.symmetric(vertical: isTabletOrUp ? 8.0 : 8.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.rSp(context)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.semiBold13(
              context,
            ).copyWith(color: Theme.of(context).colorScheme.primary),
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
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);

    return Container(
      constraints: BoxConstraints(maxWidth: isTabletOrUp ? 170.0 : 170.w),
      padding: EdgeInsets.symmetric(
        horizontal: isTabletOrUp ? 12.0 : 12.w,
        vertical: isTabletOrUp ? 8.0 : 8.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.rSp(context)),
      ),
      child: Text(
        label,
        style: TextStyles.semiBold13(
          context,
        ).copyWith(color: Theme.of(context).colorScheme.primary),
        textAlign: TextAlign.center,
      ),
    );
  }
}
