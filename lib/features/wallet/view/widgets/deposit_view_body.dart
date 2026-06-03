import 'package:flutter/material.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/core/utils/currency_formatter.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/features/wallet/model/models/wallet_models.dart';
import 'package:safqaseller/features/wallet/model/repositories/wallet_repository.dart';
import 'package:safqaseller/features/wallet/view/add_card_view.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';
import 'package:safqaseller/features/wallet/view/widgets/wallet_skeleton_data.dart';
import 'package:safqaseller/features/wallet/view_model/deposit/deposit_view_model.dart';
import 'package:safqaseller/features/wallet/view_model/deposit/deposit_view_model_state.dart';
import 'package:safqaseller/generated/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DepositViewBody extends StatefulWidget {
  const DepositViewBody({super.key});

  @override
  State<DepositViewBody> createState() => _DepositViewBodyState();
}

class _DepositViewBodyState extends State<DepositViewBody> {
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

  Future<void> _refreshCards() async {
    final future = _loadCards();
    setState(() {
      _cardsFuture = future;
    });
    await future;
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
    context.read<DepositViewModel>().deposit(
          amount,
          savedCardId: selectedCardId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    return BlocListener<DepositViewModel, DepositState>(
      listener: (context, state) {
        if (state is DepositSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).kDepositSuccessful),
              backgroundColor: Color(0xFF7DD97B),
            ),
          );
          Navigator.pop(context, true);
        } else if (state is DepositError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: buildAppBar(context: context, title: S.of(context).kDeposit),
        body: FutureBuilder<List<CardModel>>(
          future: _cardsFuture,
          builder: (context, snapshot) {
            final isInitialLoading =
                snapshot.connectionState == ConnectionState.waiting;

            if (snapshot.hasError) {
              return RefreshIndicator(
                onRefresh: _refreshCards,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: (isTabletOrUp ? 24.0 : 24.w), vertical: (isTabletOrUp ? 24.0 : 24.h)),
                  children: [
                    SizedBox(height: (isTabletOrUp ? 160.0 : 160.h)),
                    Column(
                      children: [
                        Text(
                          snapshot.error.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyles.regular16(context),
                        ),
                        SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),
                        ElevatedButton(
                          onPressed: _refreshCards,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
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
                  ],
                ),
              );
            }

            final cards = isInitialLoading
                ? WalletSkeletonData.cards
                : _sanitizeCards(snapshot.data ?? const <CardModel>[]);

            return Skeletonizer(
              enabled: isInitialLoading,
              child: RefreshIndicator(
                onRefresh: _refreshCards,
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: (isTabletOrUp ? 16.0 : 16.w), vertical: (isTabletOrUp ? 24.0 : 24.h)),
                    child: ResponsiveFormShell(
                      enabled: isTabletOrUp,
                      maxWidth: 700,
                      child: ResponsiveFormSection(
                        child: Form(
                          key: _formKey,
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).kEnterDepositAmount,
                              style: TextStyles.medium20(context),
                            ),
                            SizedBox(height: (isTabletOrUp ? 24.0 : 24.h)),
                            Text(
                              S.of(context).savedCard,
                              style: TextStyles.medium16(context),
                            ),
                            SizedBox(height: (isTabletOrUp ? 12.0 : 12.h)),
                            if (cards.isEmpty)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.rSp(context)),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12.rSp(context)),
                                  border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).kNoSavedCards,
                                      style: TextStyles.regular16(context),
                                    ),
                                    SizedBox(height: (isTabletOrUp ? 12.0 : 12.h)),
                                    ElevatedButton(
                                      onPressed: _openAddCard,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.primary,
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
                                    borderRadius: BorderRadius.circular(12.rSp(context)),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: (isTabletOrUp ? 16.0 : 16.w),
                                    vertical: (isTabletOrUp ? 14.0 : 14.h),
                                  ),
                                ),
                              ),
                            SizedBox(height: (isTabletOrUp ? 24.0 : 24.h)),
                            Container(
                              height: (isTabletOrUp ? 56.0 : 56.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.rSp(context)),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.primary.withValues(
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
                                  fontSize: 20.rSp(context),
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: (isTabletOrUp ? 16.0 : 16.w),
                                    vertical: (isTabletOrUp ? 16.0 : 16.h),
                                  ),
                                  hintText: '0.00',
                                  hintStyle: TextStyle(
                                    fontSize: 20.rSp(context),
                                    color: Colors.grey[400],
                                  ),
                                  prefixText: '${CurrencyFormatter.getSymbol()} ',
                                  prefixStyle: TextStyle(
                                    fontSize: 20.rSp(context),
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: (isTabletOrUp ? 24.0 : 24.h)),
                            BlocBuilder<DepositViewModel, DepositState>(
                              builder: (context, state) {
                                final isLoading = state is DepositLoading;
                                return SizedBox(
                                  width: double.infinity,
                                  height: (isTabletOrUp ? 54.0 : 54.h),
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : () => _submit(cards),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16.rSp(context)),
                                      ),
                                    ),
                                    child: isLoading
                                        ? SizedBox(
                                            width: (isTabletOrUp ? 22.0 : 22.w),
                                            height: (isTabletOrUp ? 22.0 : 22.w),
                                            child: const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            S.of(context).kDeposit,
                                            style: TextStyles.semiBold19(context)
                                                .copyWith(color: Colors.white),
                                          ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: (isTabletOrUp ? 16.0 : 16.h)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          },
        ),
      ),
    );
  }
}
