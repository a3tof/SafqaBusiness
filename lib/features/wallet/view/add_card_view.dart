import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/features/wallet/view/widgets/add_card_view_body.dart';
import 'package:safqaseller/features/wallet/view_model/add_card/add_card_view_model.dart';

class AddCardView extends StatelessWidget {
  const AddCardView({super.key});
  static const String routeName = 'addCard';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AddCardViewModel>(),
      child: const AddCardViewBody(),
    );
  }
}
