import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/features/wallet/view/widgets/saved_cards_view_body.dart';
import 'package:safqaseller/features/wallet/view_model/wallet/wallet_view_model.dart';

class SavedCardsView extends StatelessWidget {
  const SavedCardsView({super.key});
  static const String routeName = 'savedCards';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WalletViewModel>()..loadWallet(),
      child: const SavedCardsViewBody(),
    );
  }
}
