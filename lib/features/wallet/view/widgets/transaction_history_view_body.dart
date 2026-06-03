import 'package:flutter/material.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/features/wallet/model/models/wallet_models.dart';
import 'package:safqaseller/features/wallet/view/widgets/transaction_item.dart';
import 'package:safqaseller/features/wallet/view/widgets/wallet_skeleton_data.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';
import 'package:safqaseller/features/wallet/view_model/wallet/wallet_view_model.dart';
import 'package:safqaseller/features/wallet/view_model/wallet/wallet_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TransactionHistoryViewBody extends StatelessWidget {
  const TransactionHistoryViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: buildAppBar(context: context, title: S.of(context).kTransactions),
      body: BlocBuilder<WalletViewModel, WalletState>(
        builder: (context, state) {
          final isLoading = state is WalletLoading || state is WalletInitial;
          if (state is WalletError) {
            return Center(child: Text(state.message));
          }

          final txs = state is WalletSuccess
              ? state.transactions
              : WalletSkeletonData.transactions;

          if (txs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 64.rSp(context), color: Colors.grey),
                  SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),
                  Text(S.of(context).kNoTransactionsYet,
                      style: TextStyles.regular16(context)
                          .copyWith(color: Colors.grey)),
                ],
              ),
            );
          }

          // Group transactions by date
          final grouped = <String, List<TransactionModel>>{};
          for (final t in txs) {
            final key = DateFormat('d MMMM yyyy').format(t.date);
            grouped.putIfAbsent(key, () => []).add(t);
          }

          return Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.symmetric(horizontal: (isTabletOrUp ? 16.0 : 16.w), vertical: (isTabletOrUp ? 16.0 : 16.h)),
              child: ResponsiveFormShell(
                enabled: isTabletOrUp,
                maxWidth: 700,
                child: ResponsiveFormSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: grouped.entries.map((entry) {
                      final dateKey = entry.key;
                      final group = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateKey,
                            style: TextStyles.medium14(context)
                                .copyWith(color: const Color(0xFFAAAAAA)),
                          ),
                          SizedBox(height: (isTabletOrUp ? 12.0 : 12.h)),
                          ...group.map(
                            (t) => Padding(
                              padding: EdgeInsets.only(bottom: (isTabletOrUp ? 12.0 : 12.h)),
                              child: TransactionItem(transaction: t),
                            ),
                          ),
                          SizedBox(height: (isTabletOrUp ? 8.0 : 8.h)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
