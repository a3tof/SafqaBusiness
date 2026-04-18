import 'package:flutter/material.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/features/terms_and_conditions/view/widgets/terms_and_conditions_view_body.dart';
import 'package:safqaseller/generated/l10n.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});
  static const String routeName = 'termsAndConditions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: buildAppBar(
        context: context,
        title: S.of(context).termsAndConditions,
      ),
      body: const TermsAndConditionsViewBody(),
    );
  }
}
