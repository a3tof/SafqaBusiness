import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/utils/app_color.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/features/wallet/model/models/wallet_models.dart';
import 'package:safqaseller/features/wallet/model/repositories/wallet_repository.dart';
import 'package:safqaseller/features/wallet/view/add_card_view.dart';
import 'package:safqaseller/features/wallet/view_model/withdrawal/withdrawal_view_model.dart';
import 'package:safqaseller/features/wallet/view_model/withdrawal/withdrawal_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';

class WithdrawalViewBody extends StatefulWidget {
  const WithdrawalViewBody({super.key});

  @override
  State<WithdrawalViewBody> createState() => _WithdrawalViewBodyState();
}

class _WithdrawalViewBodyState extends State<WithdrawalViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  late Future<List<CardModel>> _cardsFuture;
  int? _selectedCardId;

  @override
  void initState() {
    super.initState();
    _cardsFuture = _loadCards();
  }

  Future<List<CardModel>> _loadCards() async {
    final cards = _sanitizeCards(await getIt<WalletRepository>().getCards());
    _selectedCardId = cards.any((card) => card.id == _selectedCardId)
        ? _selectedCardId
        : (cards.isNotEmpty ? cards.first.id : null);
    return cards;
  }

  List<CardModel> _sanitizeCards(List<CardModel> cards) {
    final seen = <int>{};
    return cards.where((card) {
      if (card.id <= 0 || seen.contains(card.id)) return false;
      seen.add(card.id);
      return true;
    }).toList();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _openAddCard() async {
    final created = await Navigator.pushNamed(context, AddCardView.routeName);
    if (created == true && mounted) {
      setState(() {
        _cardsFuture = _loadCards();
      });
    }
  }

  void _submit(List<CardModel> cards) {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) return;
    final selectedCardId =
        _selectedCardId ?? (cards.isNotEmpty ? cards.first.id : null);
    if (selectedCardId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).kNoSavedCards),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    context.read<WithdrawalViewModel>().withdraw(
      amount,
      cardId: selectedCardId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WithdrawalViewModel, WithdrawalState>(
      listener: (context, state) {
        if (state is WithdrawalSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).kWithdrawalSuccessfu),
              backgroundColor: const Color(0xFF7DD97B),
            ),
          );
          Navigator.pop(context, true);
        } else if (state is WithdrawalError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context: context, title: S.of(context).kWithdrawal),
        body: FutureBuilder<List<CardModel>>(
          future: _cardsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyles.regular16(context),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _cardsFuture = _loadCards();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: Text(
                          S.of(context).retry,
                          style: TextStyles.semiBold16(
                            context,
                          ).copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final cards = _sanitizeCards(snapshot.data ?? const <CardModel>[]);

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).kEnterWithdrawalAmo,
                            style: TextStyles.medium20(context),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            S.of(context).savedCard,
                            style: TextStyles.medium16(context),
                          ),
                          SizedBox(height: 12.h),
                          if (cards.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    S.of(context).kNoSavedCards,
                                    style: TextStyles.regular16(context),
                                  ),
                                  SizedBox(height: 12.h),
                                  ElevatedButton(
                                    onPressed: _openAddCard,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                    ),
                                    child: Text(
                                      S.of(context).kAddCard,
                                      style: TextStyles.semiBold16(
                                        context,
                                      ).copyWith(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            DropdownButtonFormField<int>(
                              initialValue:
                                  cards.any((card) => card.id == _selectedCardId)
                                  ? _selectedCardId
                                  : cards.first.id,
                              items: cards
                                  .map(
                                    (card) => DropdownMenuItem<int>(
                                      value: card.id,
                                      child: Text(
                                        '${card.label?.isNotEmpty == true ? card.label! : S.of(context).card} •••• ${card.last4}',
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCardId = value;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 14.h,
                                ),
                              ),
                            ),
                          SizedBox(height: 24.h),
                          Container(
                            height: 56.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.primaryColor,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withValues(
                                    alpha: 0.08,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _amountCtrl,
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return S.of(context).enterAmount;
                                }
                                final number = double.tryParse(value.trim());
                                if (number == null || number <= 0) {
                                  return S.of(context).enterValidAmount;
                                }
                                return null;
                              },
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                                hintText: '0.00',
                                hintStyle: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.grey[400],
                                ),
                                prefixText: '\$ ',
                                prefixStyle: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 40.h),
                    child: BlocBuilder<WithdrawalViewModel, WithdrawalState>(
                      builder: (context, state) {
                        final isLoading = state is WithdrawalLoading;
                        return SizedBox(
                          width: double.infinity,
                          height: 54.h,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () => _submit(cards),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: 22.w,
                                    height: 22.w,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    S.of(context).kWithdrawal,
                                    style: TextStyles.semiBold19(
                                      context,
                                    ).copyWith(color: Colors.white),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
