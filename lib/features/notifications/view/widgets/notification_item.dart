import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/notifications/model/models/notification_model.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notification,
    required this.selectionMode,
    required this.selected,
    this.onTap,
    this.onActionTap,
    this.onLongPress,
  });

  final NotificationModel notification;
  final bool selectionMode;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onActionTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cardColor = _cardBackground(context);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light
                  ? scheme.shadow.withValues(alpha: 0.06)
                  : scheme.shadow.withValues(alpha: 0.12),
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectionMode)
              _SelectionLeading(
                selected: selected,
              )
            else
              _NotificationIcon(type: notification.type),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyles.semiBold16(
                            context,
                          ).copyWith(color: scheme.onSurface),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        notification.timeAgo,
                        style: TextStyles.regular12(
                          context,
                        ).copyWith(color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    notification.message,
                    style: TextStyles.regular14(
                      context,
                    ).copyWith(color: Theme.of(context).hintColor),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                              color: scheme.primary,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              notification.actionLabel!,
                              style: TextStyles.medium16(
                                context,
                              ).copyWith(color: scheme.onPrimary),
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
      ),
    );
  }

  Color _cardBackground(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (selectionMode && selected) {
      return scheme.primary.withValues(alpha: 0.12);
    }
    if (!notification.isRead) {
      return scheme.primary.withValues(alpha: 0.08);
    }
    return Theme.of(context).cardColor;
  }
}

class _SelectionLeading extends StatelessWidget {
  const _SelectionLeading({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: selected ? scheme.primary : null,
        shape: BoxShape.circle,
        border: selected
            ? null
            : Border.all(
                color: scheme.primary,
                width: 2,
              ),
      ),
      child: selected
          ? Icon(Icons.check_rounded, color: scheme.onPrimary, size: 26.sp)
          : null,
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({required this.type});
  final NotificationType type;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: scheme.secondary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          _iconData,
          color: scheme.primary,
          size: 24.sp,
        ),
      ),
    );
  }

  IconData get _iconData {
    switch (type) {
      case NotificationType.auctionReminder:
        return Icons.calendar_month_rounded;
      case NotificationType.newAuction:
        return Icons.gavel_rounded;
      case NotificationType.report:
        return Icons.report_outlined;
      case NotificationType.orderOnTheWay:
        return Icons.local_shipping_rounded;
    }
  }
}
