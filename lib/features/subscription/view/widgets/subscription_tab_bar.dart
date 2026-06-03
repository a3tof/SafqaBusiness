import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';

class SubscriptionTabBar extends StatelessWidget {
  const SubscriptionTabBar({
    super.key,
    required this.tabController,
    required this.labels,
  });

  final TabController tabController;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final radius = BorderRadius.circular(22.rSp(context));

    return Material(
      color: primary.withValues(alpha: 0.08),
      borderRadius: radius,
      child: Container(
        height: isTabletOrUp ? 44.0 : 44.h,
        padding: EdgeInsets.all(isTabletOrUp ? 4.0 : 4.w),
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: primary.withValues(alpha: 0.22)),
        ),
        child: TabBar(
          controller: tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(18.rSp(context)),
            color: primary,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: theme.colorScheme.surface.withValues(alpha: 0),
          labelColor: theme.colorScheme.onPrimary,
          unselectedLabelColor: primary,
          labelStyle: TextStyles.semiBold13(context),
          unselectedLabelStyle: TextStyles.regular13(context),
          splashBorderRadius: BorderRadius.circular(18.rSp(context)),
          overlayColor: WidgetStatePropertyAll(primary.withValues(alpha: 0.06)),
          tabs: labels.map((label) => Tab(text: label)).toList(),
        ),
      ),
    );
  }
}
