import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/wallet/model/models/wallet_models.dart';

/// Single row in the transaction history list.
/// Design: #FAFAFA card, title (#064061), date (#AAA), amount (colored).
class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.transaction});

  final TransactionModel transaction;

  static const _titleColor = Color(0xFF064061);
  static const _dateColor = Color(0xFFAAAAAA);
  // Amount colours per type
  static const _withdrawalColor = Color(0xFFF3735E);
  static const _depositColor = Color(0xFF7DD97B);
  static const _auctionColor = Color(0xFFE9653B);

  Color get _amountColor {
    switch (transaction.type) {
      case TransactionType.withdrawal:
        return _withdrawalColor;
      case TransactionType.deposit:
        return _depositColor;
      case TransactionType.auctionDeposit:
        return _auctionColor;
      case TransactionType.other:
        return Colors.black;
    }
  }

  String get _sign =>
      transaction.type == TransactionType.deposit ? '+' : '-';

  @override
  Widget build(BuildContext context) {
    final dateStr =
        DateFormat('d MMM, yyyy').format(transaction.date);
    final amountStr =
        '\$$_sign${NumberFormat('#,##0.##').format(transaction.amount)}';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.title,
                style: TextStyles.medium15(context)
                    .copyWith(color: _titleColor),
              ),
              SizedBox(height: 6.h),
              Text(
                dateStr,
                style: TextStyles.regular14(context)
                    .copyWith(color: _dateColor),
              ),
            ],
          ),
          Text(
            amountStr,
            style: TextStyles.semiBold16(context).copyWith(color: _amountColor),
          ),
        ],
      ),
    );
  }
}
