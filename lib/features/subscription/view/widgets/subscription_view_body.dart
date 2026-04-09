import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/features/subscription/model/subscription_plan_model.dart';
import 'package:safqaseller/features/subscription/view/widgets/subscription_plan_card.dart';
import 'package:safqaseller/features/subscription/view/widgets/subscription_tab_bar.dart';
import 'package:safqaseller/features/subscription/view_model/subscription_view_model.dart';
import 'package:safqaseller/features/subscription/view_model/subscription_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SubscriptionViewBody extends StatefulWidget {
  const SubscriptionViewBody({super.key});

  @override
  State<SubscriptionViewBody> createState() => _SubscriptionViewBodyState();
}

class _SubscriptionViewBodyState extends State<SubscriptionViewBody>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionViewModel, SubscriptionState>(
      builder: (context, state) {
        final plans = SubscriptionPlanModel.plans(context);
        final isSkeletonLoading = state is SubscriptionScreenLoading;

        return Skeletonizer(
          enabled: isSkeletonLoading,
          child: RefreshIndicator(
            onRefresh: () async {
              final viewModel = context.read<SubscriptionViewModel>();
              await viewModel.loadActivePlan();
              if (!context.mounted) return;
              _jumpToActivePlanTab(viewModel.state.activePlanId);
            },
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 4.h),
                        Center(child: _buildLogo()),
                        SizedBox(height: 24.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: SubscriptionTabBar(
                            tabController: _tabController,
                            labels: [
                              S.of(context).kBasic,
                              S.of(context).kPremium,
                              S.of(context).kElite,
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.72,
                          child: TabBarView(
                            controller: _tabController,
                            children: plans
                                .map((plan) => SubscriptionPlanCard(plan: plan))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _jumpToActivePlanTab(String? activePlanId) {
    final planIndex = int.tryParse(activePlanId ?? '');
    if (planIndex == null) return;

    final tabIndex = planIndex - 1;
    if (tabIndex < 0 || tabIndex >= _tabController.length) return;

    _tabController.animateTo(tabIndex);
  }

  Widget _buildLogo() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'safqa',
            style: TextStyle(
              fontFamily: 'AlegreyaSC',
              fontSize: 40.sp,
              fontWeight: FontWeight.normal,
              color: AppColors.primaryColor,
            ),
          ),
          TextSpan(
            text: '.',
            style: TextStyle(
              fontFamily: 'AlegreyaSC',
              fontSize: 40.sp,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF808080),
            ),
          ),
          TextSpan(
            text: 'Business',
            style: TextStyle(
              fontFamily: 'AlegreyaSC',
              fontSize: 24.sp,
              fontWeight: FontWeight.normal,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
