import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/features/subscription/view/widgets/subscription_view_body.dart';
import 'package:safqaseller/features/subscription/view_model/subscription_view_model.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});
  static const String routeName = 'subscription';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SubscriptionViewModel>(),
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: SubscriptionViewBody(),
      ),
    );
  }
}
