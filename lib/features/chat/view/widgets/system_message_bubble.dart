import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/responsive/responsive.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';

class SystemMessageBubble extends StatelessWidget {
  const SystemMessageBubble({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 18.r,
              ),
            ),
            SizedBox(width: 10.r),
            Expanded(
              child: Text(
                text,
                style: TextStyles.regular14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: responsiveValue<double>(
                    context,
                    mobile: 14.sp,
                    tablet: 12.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
