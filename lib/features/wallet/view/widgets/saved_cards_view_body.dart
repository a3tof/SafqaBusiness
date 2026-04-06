import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/wallet/view/add_card_view.dart';
import 'package:safqaseller/features/wallet/view/widgets/card_list_item.dart';
import 'package:safqaseller/features/wallet/view_model/wallet/wallet_view_model.dart';
import 'package:safqaseller/features/wallet/view_model/wallet/wallet_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';

class SavedCardsViewBody extends StatelessWidget {
  const SavedCardsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryColor, size: 22.sp),
        ),
        title: Text(
          'Saved Cards',
          style: TextStyle(
            fontFamily: 'AlegreyaSC',
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AddCardView.routeName),
            icon: Icon(Icons.add_rounded,
                color: AppColors.primaryColor, size: 28.sp),
          ),
        ],
      ),
      body: BlocBuilder<WalletViewModel, WalletState>(
        builder: (context, state) {
          if (state is WalletLoading || state is WalletInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WalletError) {
            return Center(child: Text(state.message));
          }

          final cards = (state as WalletSuccess).cards;

          if (cards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.credit_card_off_outlined,
                      size: 64.sp, color: Colors.grey),
                  SizedBox(height: 16.h),
                  Text(S.of(context).kNoSavedCards,
                      style: TextStyles.regular16(context)
                          .copyWith(color: Colors.grey)),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AddCardView.routeName),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor),
                    child: Text(S.of(context).kAddCard,
                        style: TextStyles.semiBold16(context)
                            .copyWith(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            itemCount: cards.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, thickness: 0.5),
            itemBuilder: (context, i) => Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: CardListItem(
                card: cards[i],
                onDelete: () =>
                    context.read<WalletViewModel>().deleteCard(cards[i].id),
              ),
            ),
          );
        },
      ),
    );
  }
}
