import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/features/wallet/view/widgets/deposit_view_body.dart';
import 'package:safqaseller/features/wallet/view_model/deposit/deposit_view_model.dart';

class DepositView extends StatelessWidget {
  const DepositView({super.key});
  static const String routeName = 'deposit';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DepositViewModel>(),
      child: const DepositViewBody(),
    );
  }
}
