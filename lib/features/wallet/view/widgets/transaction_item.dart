import 'package:flutter/material.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/utils/currency_formatter.dart';
import 'package:safqaseller/features/wallet/model/models/wallet_models.dart';

/// Single row in the transaction history list.
/// Design: #FAFAFA card, title (#064061), date (#AAA), amount (colored).
class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.transaction});

  final TransactionModel transaction;

  // Amount colours per type
  static const _withdrawalColor = Color(0xFFBA1A1A);
  static const _depositColor = Color(0xFF00762E);
  static const _auctionColor = Color(0xFF00762E);

  Color _amountColor(BuildContext context) {
    switch (transaction.type) {
      case TransactionType.withdrawal:
        return _withdrawalColor;
      case TransactionType.deposit:
        return _depositColor;
      case TransactionType.auctionDeposit:
        return _auctionColor;
      case TransactionType.other:
        return Theme.of(context).colorScheme.onSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateStr = DateFormat('d MMM, yyyy', locale).format(transaction.date);
    final amountStr = CurrencyFormatter.format(transaction.amount);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all((isTabletOrUp ? 16.0 : 16.w)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.rSp(context)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.medium15(
                    context,
                  ).copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                SizedBox(height: (isTabletOrUp ? 6.0 : 6.h)),
                Text(
                  dateStr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.regular14(
                    context,
                  ).copyWith(color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ),
          SizedBox(width: (isTabletOrUp ? 12.0 : 12.w)),
          Text(
            amountStr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.semiBold16(
              context,
            ).copyWith(color: _amountColor(context)),
          ),
        ],
      ),
    );
  }
}
