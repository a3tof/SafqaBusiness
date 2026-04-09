import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/subscription/model/subscription_plan_model.dart';
import 'package:safqaseller/features/subscription/view_model/subscription_view_model.dart';
import 'package:safqaseller/features/subscription/view_model/subscription_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';

class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({super.key, required this.plan});

  final SubscriptionPlanModel plan;

  @override
  Widget build(BuildContext context) {
    final planId = plan.upgradeType.toString();

    return BlocConsumer<SubscriptionViewModel, SubscriptionState>(
      listenWhen: (_, state) {
        if (state is SubscriptionSuccess) {
          return state.planId == planId;
        }
        if (state is SubscriptionError) {
          return state.planId == planId;
        }
        return false;
      },
      listener: (context, state) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (state is SubscriptionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).kSubscriptionUpgradeSuccess)),
          );
        } else if (state is SubscriptionError) {
          final message = state.message.isEmpty
              ? S.of(context).kSubscriptionUpgradeFailed
              : state.message;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      builder: (context, state) {
        final isLoading =
            state is SubscriptionLoading && state.planId == planId;
        final isBusy = state is SubscriptionLoading;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Text(
                plan.name,
                style: TextStyles.bold22(
                  context,
                ).copyWith(color: AppColors.primaryColor),
              ),
              SizedBox(height: 20.h),
              Icon(
                Icons.campaign_outlined,
                size: 64.sp,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: 16.h),
              Text(
                plan.price,
                style: TextStyles.bold28(
                  context,
                ).copyWith(color: AppColors.primaryColor),
              ),
              SizedBox(height: 32.h),
              ...plan.features.map(
                (feature) => Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.primaryColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyles.regular13(
                            context,
                          ).copyWith(color: const Color(0xFF4A4A4A)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: isBusy
                      ? null
                      : () {
                          context.read<SubscriptionViewModel>().upgrade(
                            upgradeType: plan.upgradeType,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primaryColor.withValues(
                      alpha: 0.7,
                    ),
                    disabledForegroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          plan.ctaLabel,
                          style: TextStyles.semiBold16(
                            context,
                          ).copyWith(color: Colors.white),
                        ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }
}
