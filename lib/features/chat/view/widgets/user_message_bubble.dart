import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/responsive/responsive.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';

class UserMessageBubble extends StatelessWidget {
  const UserMessageBubble({
    super.key,
    required this.text,
    this.createdAt,
    this.isSeen = false,
    this.isSending = false,
    this.isFailed = false,
    this.onResend,
  });

  final String text;
  final DateTime? createdAt;
  final bool isSeen;
  final bool isSending;
  final bool isFailed;
  final VoidCallback? onResend;

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 10.r),
      decoration: BoxDecoration(
        color: isFailed ? Theme.of(context).colorScheme.error.withOpacity(0.8) : Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            text,
            style: TextStyles.regular14(context).copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: responsiveValue<double>(
                context,
                mobile: 14.sp,
                tablet: 12.0,
              ),
            ),
          ),
          if (createdAt != null) ...[
            SizedBox(height: 4.r),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${createdAt!.hour.toString().padLeft(2, '0')}:${createdAt!.minute.toString().padLeft(2, '0')}',
                  style: TextStyles.regular12(context).copyWith(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(width: 4.r),
                if (isFailed)
                  Icon(
                    Icons.error_outline,
                    size: 14.r,
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
                  )
                else if (isSending)
                  SizedBox(
                    width: 12.r,
                    height: 12.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                    ),
                  )
                else
                  Icon(
                    isSeen ? Icons.done_all : Icons.check,
                    size: 14.r,
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                  ),
              ],
            ),
          ],
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 12.r, left: 40.r),
      child: Align(
        alignment: Alignment.centerRight,
        child: isFailed && onResend != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    color: Theme.of(context).colorScheme.error,
                    onPressed: onResend,
                    tooltip: 'Resend',
                  ),
                  Flexible(child: bubble),
                ],
              )
            : bubble,
      ),
    );
  }
}
