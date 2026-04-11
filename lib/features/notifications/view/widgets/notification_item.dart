import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/notifications/model/models/notification_model.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notification,
    this.onTap,
    this.onActionTap,
    this.onLongPress,
  });

  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onActionTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0F000000),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Icon bubble ──────────────────────────────────────────────
              _NotificationIcon(type: notification.type),
              SizedBox(width: 16.w),
              // ── Content ──────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyles.medium16(
                              context,
                            ).copyWith(color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          notification.timeAgo,
                          style: TextStyles.semiBold14(
                            context,
                          ).copyWith(color: const Color(0xFF666666)),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Message
                    Text(
                      notification.message,
                      style: TextStyles.regular14(
                        context,
                      ).copyWith(color: const Color(0xFF999999)),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Optional action button (e.g. "Open Chat" for Report type)
                    if (notification.hasAction &&
                        notification.actionLabel != null)
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: GestureDetector(
                            onTap: onActionTap,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                notification.actionLabel!,
                                style: TextStyles.medium16(
                                  context,
                                ).copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

// ── Icon widget ────────────────────────────────────────────────────────────────

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({required this.type});
  final NotificationType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      height: 48.h,
      decoration: const BoxDecoration(
        color: AppColors.secondaryColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(_iconData, color: AppColors.primaryColor, size: 24.sp),
      ),
    );
  }

  IconData get _iconData {
    switch (type) {
      case NotificationType.auctionReminder:
        return Icons.date_range_rounded;
      case NotificationType.newAuction:
        return Icons.gavel_rounded;
      case NotificationType.report:
        return Icons.report_outlined;
      case NotificationType.orderOnTheWay:
        return Icons.local_shipping_rounded;
    }
  }
}
