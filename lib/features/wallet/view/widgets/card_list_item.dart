import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/wallet/model/models/wallet_models.dart';

/// Single card row in the Saved Cards list.
/// Design: card icon + "Master Card" + masked number + 3-dot menu.
class CardListItem extends StatelessWidget {
  const CardListItem({
    super.key,
    required this.card,
    required this.onDelete,
  });

  final CardModel card;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Card brand icon (mastercard-style circles)
        SizedBox(
          width: 32.w,
          height: 32.w,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                child: Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEB001B),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF79E1B).withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        // Card info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.label?.isNotEmpty == true ? card.label! : 'Master Card',
                style: TextStyles.medium18(context),
              ),
              SizedBox(height: 2.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '.... .... .... ',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                    TextSpan(
                      text: card.last4,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 3-dot menu
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') onDelete();
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'delete',
              child: Text(
                'Delete',
                style: TextStyles.regular14(context)
                    .copyWith(color: Colors.red),
              ),
            ),
          ],
          icon: Icon(
            Icons.more_vert_rounded,
            color: AppColors.primaryColor,
            size: 28.sp,
          ),
        ),
      ],
    );
  }
}
