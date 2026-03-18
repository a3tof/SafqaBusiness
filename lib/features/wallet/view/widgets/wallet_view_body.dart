import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/features/wallet/model/models/wallet_models.dart';
import 'package:safqaseller/features/wallet/view/add_card_view.dart';
import 'package:safqaseller/features/wallet/view/deposit_view.dart';
import 'package:safqaseller/features/wallet/view/saved_cards_view.dart';
import 'package:safqaseller/features/wallet/view/transaction_history_view.dart';
import 'package:safqaseller/features/wallet/view/widgets/transaction_item.dart';
import 'package:safqaseller/features/wallet/view/widgets/wallet_action_button.dart';
import 'package:safqaseller/features/wallet/view/withdrawal_view.dart';
import 'package:safqaseller/features/wallet/view_model/wallet/wallet_view_model.dart';
import 'package:safqaseller/features/wallet/view_model/wallet/wallet_view_model_state.dart';

class WalletViewBody extends StatelessWidget {
  const WalletViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context: context, title: 'Wallet'),
      body: BlocBuilder<WalletViewModel, WalletState>(
        builder: (context, state) {
          if (state is WalletLoading || state is WalletInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WalletError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message,
                      style: TextStyles.regular16(context),
                      textAlign: TextAlign.center),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<WalletViewModel>().loadWallet(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final s = state as WalletSuccess;
          return RefreshIndicator(
            onRefresh: () => context.read<WalletViewModel>().loadWallet(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  // ── Balance + action buttons row ─────────────────────────
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final screenW = MediaQuery.of(context).size.width;
                      final isNarrow = screenW < 340 ||
                          constraints.maxWidth < 280;
                      return isNarrow
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _BalanceSection(balance: s.balance),
                                SizedBox(height: 16.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: [
                                    WalletActionButton(
                                      icon: Icons.add_rounded,
                                      label: 'Deposit\nmoney',
                                      onTap: () => Navigator.pushNamed(
                                          context, DepositView.routeName),
                                      filled: true,
                                    ),
                                    SizedBox(width: 20.w),
                                    WalletActionButton(
                                      icon: Icons.swap_horiz_rounded,
                                      label: 'Withdrawal\nmoney',
                                      onTap: () => Navigator.pushNamed(
                                          context, WithdrawalView.routeName),
                                      filled: false,
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: _BalanceSection(balance: s.balance),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    WalletActionButton(
                                      icon: Icons.add_rounded,
                                      label: 'Deposit\nmoney',
                                      onTap: () => Navigator.pushNamed(
                                          context, DepositView.routeName),
                                      filled: true,
                                    ),
                                    SizedBox(width: 20.w),
                                    WalletActionButton(
                                      icon: Icons.swap_horiz_rounded,
                                      label: 'Withdrawal\nmoney',
                                      onTap: () => Navigator.pushNamed(
                                          context, WithdrawalView.routeName),
                                      filled: false,
                                    ),
                                  ],
                                ),
                              ],
                            );
                    },
                  ),

                  SizedBox(height: 28.h),
                  // ── Saved Cards ──────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Saved Cards',
                        style: TextStyles.medium20(context),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(
                            context, SavedCardsView.routeName),
                        child: Text(
                          'See all',
                          style: TextStyles.regular14(context).copyWith(
                            color: AppColors.primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  if (s.cards.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Column(
                          children: [
                            Icon(Icons.credit_card_off_outlined,
                                size: 48.sp, color: Colors.grey),
                            SizedBox(height: 8.h),
                            Text('No saved cards',
                                style: TextStyles.regular14(context)
                                    .copyWith(color: Colors.grey)),
                          ],
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 215.h,
                      child: PageView.builder(
                        itemCount: s.cards.length,
                        itemBuilder: (_, i) => _CreditCardWidget(card: s.cards[i]),
                      ),
                    ),

                  SizedBox(height: 4.h),
                  // ── Add card shortcut ────────────────────────────────────
                  TextButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, AddCardView.routeName),
                    icon: Icon(Icons.add_circle_outline,
                        size: 20.sp, color: AppColors.primaryColor),
                    label: Text(
                      'Add new card',
                      style: TextStyles.medium14(context)
                          .copyWith(color: AppColors.primaryColor),
                    ),
                  ),

                  SizedBox(height: 16.h),
                  // ── Transaction History ──────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Transaction History',
                          style: TextStyles.medium20(context)),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(
                            context, TransactionHistoryView.routeName),
                        child: Text(
                          'See all',
                          style: TextStyles.regular14(context).copyWith(
                            color: AppColors.primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (s.transactions.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Text('No transactions yet',
                            style: TextStyles.regular14(context)
                                .copyWith(color: Colors.grey)),
                      ),
                    )
                  else ...[
                    // Date header for the first group
                    Text(
                      DateFormat('d MMMM yyyy')
                          .format(s.transactions.first.date),
                      style: TextStyles.medium14(context)
                          .copyWith(color: const Color(0xFFAAAAAA)),
                    ),
                    SizedBox(height: 12.h),
                    ...s.transactions
                        .take(3)
                        .map((t) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: TransactionItem(transaction: t),
                            )),
                  ],
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Private sub-widgets ────────────────────────────────────────────────────────

class _BalanceSection extends StatelessWidget {
  const _BalanceSection({required this.balance});
  final WalletBalance balance;

  @override
  Widget build(BuildContext context) {
    final parts = balance.balance.toStringAsFixed(2).split('.');
    final whole = parts[0];
    final decimal = parts[1];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wallet balance',
          style: TextStyles.regular18(context)
              .copyWith(color: const Color(0xFF666666)),
        ),
        SizedBox(height: 4.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              whole,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Text(
                '.$decimal',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Visual credit card widget displayed in the saved-cards carousel.
class _CreditCardWidget extends StatelessWidget {
  const _CreditCardWidget({required this.card});
  final CardModel card;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 215.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF023E8A), Color(0xFF0077B6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.label?.isNotEmpty == true ? card.label! : 'Credit Card',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              Text(
                'VISA',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '.... .... .... ${card.last4}',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARD HOLDER',
                    style: TextStyle(
                        fontSize: 10.sp, color: Colors.white70),
                  ),
                  Text(
                    card.cardholderName.toUpperCase(),
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('EXPIRES',
                      style: TextStyle(fontSize: 10.sp, color: Colors.white70)),
                  Text(
                    card.expiryDate,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
