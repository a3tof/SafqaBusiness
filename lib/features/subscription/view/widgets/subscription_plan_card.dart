import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
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
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
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
        final activePlanId = int.tryParse(state.activePlanId ?? '');
        final isCurrentPlan = activePlanId == plan.upgradeType;
        final isIncludedInHigherPlan =
            activePlanId != null && activePlanId > plan.upgradeType;
        final canUpgrade =
            !isLoading &&
            !isCurrentPlan &&
            !isIncludedInHigherPlan &&
            (activePlanId == null || plan.upgradeType > activePlanId);
        final buttonLabel = _buttonLabel(
          context,
          isCurrentPlan: isCurrentPlan,
          isIncludedInHigherPlan: isIncludedInHigherPlan,
        );
        final theme = Theme.of(context);
        final primary = theme.colorScheme.primary;
        final onPrimary = theme.colorScheme.onPrimary;
        final buttonColor = canUpgrade
            ? primary
            : primary.withValues(alpha: 0.55);
        final cardBorderColor = isCurrentPlan
            ? primary.withValues(alpha: 0.22)
            : primary.withValues(alpha: 0.12);

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isTabletOrUp ? 20.0 : 20.w,
          ),
          child: Column(
            children: [
              SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(18.rSp(context)),
                  border: Border.all(color: cardBorderColor),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    if (isCurrentPlan)
                      Positioned.fill(
                        child: ColoredBox(
                          color: primary.withValues(alpha: 0.09),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        isTabletOrUp ? 20.0 : 20.w,
                        isTabletOrUp ? 24.0 : 24.h,
                        isTabletOrUp ? 20.0 : 20.w,
                        isTabletOrUp ? 22.0 : 22.h,
                      ),
                      child: Column(
                        children: [
                          Text(
                            plan.name,
                            style: TextStyles.bold22(
                              context,
                            ).copyWith(color: primary),
                          ),
                          SizedBox(height: isTabletOrUp ? 18.0 : 18.h),
                          Icon(
                            Icons.campaign_outlined,
                            size: 56.rSp(context),
                            color: primary,
                          ),
                          SizedBox(height: isTabletOrUp ? 14.0 : 14.h),
                          Text(
                            plan.price,
                            style: TextStyles.bold28(
                              context,
                            ).copyWith(color: primary),
                          ),
                          SizedBox(height: isTabletOrUp ? 28.0 : 28.h),
                          ...plan.features.map(
                            (feature) => Padding(
                              padding: EdgeInsets.only(
                                bottom: isTabletOrUp ? 12.0 : 12.h,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: primary,
                                    size: 20.rSp(context),
                                  ),
                                  SizedBox(width: isTabletOrUp ? 12.0 : 12.w),
                                  Expanded(
                                    child: Text(
                                      feature,
                                      style: TextStyles.regular14(context)
                                          .copyWith(
                                            color: theme.colorScheme.onSurface,
                                            height: 1.35,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isTabletOrUp ? 24.0 : 24.h),
              SizedBox(
                width: double.infinity,
                height: isTabletOrUp ? 50.0 : 50.h,
                child: ElevatedButton(
                  onPressed: canUpgrade
                      ? () {
                          context.read<SubscriptionViewModel>().upgrade(
                            upgradeType: plan.upgradeType,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: onPrimary,
                    disabledBackgroundColor: buttonColor,
                    disabledForegroundColor: onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.rSp(context)),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: isTabletOrUp ? 22.0 : 22.w,
                          height: isTabletOrUp ? 22.0 : 22.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          buttonLabel,
                          style: TextStyles.semiBold16(
                            context,
                          ).copyWith(color: onPrimary),
                        ),
                ),
              ),
              SizedBox(height: isTabletOrUp ? 20.0 : 20.h),
            ],
          ),
        );
      },
    );
  }

  String _buttonLabel(
    BuildContext context, {
    required bool isCurrentPlan,
    required bool isIncludedInHigherPlan,
  }) {
    if (isCurrentPlan) {
      return S.of(context).kCurrentPlan;
    }
    if (isIncludedInHigherPlan) {
      return S.of(context).kIncludedInCurrentPlan;
    }
    return plan.ctaLabel;
  }
}
