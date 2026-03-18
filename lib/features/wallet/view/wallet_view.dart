import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/features/wallet/view/widgets/wallet_view_body.dart';
import 'package:safqaseller/features/wallet/view_model/wallet/wallet_view_model.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});
  static const String routeName = 'wallet';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WalletViewModel>()..loadWallet(),
      child: const WalletViewBody(),
    );
  }
}
