import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/responsive/responsive.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';

class OtherMessageBubble extends StatelessWidget {
  const OtherMessageBubble({
    super.key,
    required this.text,
    this.createdAt,
  });

  final String text;
  final DateTime? createdAt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.r, right: 40.r),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 10.r),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                text,
                style: TextStyles.regular14(context).copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: responsiveValue<double>(
                    context,
                    mobile: 14.sp,
                    tablet: 12.0,
                  ),
                ),
              ),
              if (createdAt != null) ...[
                SizedBox(height: 4.r),
                Text(
                  '${createdAt!.hour.toString().padLeft(2, '0')}:${createdAt!.minute.toString().padLeft(2, '0')}',
                  style: TextStyles.regular12(context).copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
