import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/features/wallet/view/widgets/withdrawal_view_body.dart';
import 'package:safqaseller/features/wallet/view_model/withdrawal/withdrawal_view_model.dart';

class WithdrawalView extends StatelessWidget {
  const WithdrawalView({super.key});
  static const String routeName = 'withdrawal';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WithdrawalViewModel>(),
      child: const WithdrawalViewBody(),
    );
  }
}
