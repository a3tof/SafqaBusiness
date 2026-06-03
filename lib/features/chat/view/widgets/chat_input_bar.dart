import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/constants.dart';
import 'package:safqaseller/core/responsive/responsive.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/generated/l10n.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kHorizontalPadding.r,
        vertical: 8.r,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: responsiveValue<double>(
                  context,
                  mobile: 44.r,
                  tablet: 40.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: S.of(context).chatTypeMessage,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.r,
                      vertical: 10.r,
                    ),
                    hintStyle: TextStyles.regular14(context).copyWith(
                      color: Theme.of(context).hintColor,
                      fontSize: responsiveValue<double>(
                        context,
                        mobile: 14.sp,
                        tablet: 12.0,
                      ),
                    ),
                  ),
                  style: TextStyles.regular14(context).copyWith(
                    fontSize: responsiveValue<double>(
                      context,
                      mobile: 14.sp,
                      tablet: 12.0,
                    ),
                  ),
                  onSubmitted: (_) => onSend(),
                ),
              ),
            ),
            SizedBox(width: 8.r),
            GestureDetector(
              onTap: onSend,
              child: Container(
                width: responsiveValue<double>(
                  context,
                  mobile: 44.r,
                  tablet: 40.0,
                ),
                height: responsiveValue<double>(
                  context,
                  mobile: 44.r,
                  tablet: 40.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                  ),
                ),
                child: Icon(
                  Icons.send,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
