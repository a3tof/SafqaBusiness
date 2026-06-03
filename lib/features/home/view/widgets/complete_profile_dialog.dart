import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/complete_profile/view/account_type_view.dart';

/// Dialog shown when the seller has not yet completed their profile.
///
/// When [forcedMode] is `true`, the dismiss (×) button is hidden and the
/// background barrier is non-dismissible, forcing the seller to either
/// start profile completion or close the app.
class CompleteProfileDialog extends StatelessWidget {
  const CompleteProfileDialog({
    super.key,
    required this.onComplete,
    this.forcedMode = false,
  });

  final VoidCallback onComplete;

  /// When true, the close button is hidden so the dialog cannot be dismissed.
  final bool forcedMode;

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.rSp(context)),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        insetPadding: EdgeInsets.symmetric(horizontal: isTabletOrUp ? 16.0 : 16.w),
        child: Padding(
          padding: isTabletOrUp 
              ? const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0)
              : EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button — hidden in forced mode
              if (!forcedMode)
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.red,
                      size: 24.rSp(context),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                )
              else
                SizedBox(height: isTabletOrUp ? 8.0 : 8.h),
              SizedBox(height: isTabletOrUp ? 4.0 : 4.h),
              // Description with partial blue highlight
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'To start your first deal, ',
                      style: TextStyles.semiBold16(
                        context,
                      ).copyWith(color: Theme.of(context).colorScheme.primary, height: 1.4),
                    ),
                    TextSpan(
                      text:
                          'please complete your profile. '
                          'This ensures the rights of both you and the buyer.',
                      style: TextStyles.semiBold16(
                        context,
                      ).copyWith(color: const Color(0xFF666666), height: 1.4),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isTabletOrUp ? 16.0 : 16.h),
              // Action button
              SizedBox(
                width: double.infinity,
                height: isTabletOrUp ? 40.0 : 40.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(AccountTypeView.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.rSp(context)),
                    ),
                  ),
                  child: Text(
                    'Complete Profile Now',
                    style: TextStyles.semiBold16(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
