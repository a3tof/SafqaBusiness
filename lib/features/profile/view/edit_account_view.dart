import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/features/profile/view/widgets/edit_account_view_body.dart';
import 'package:safqaseller/features/profile/view_model/edit_account/edit_account_view_model.dart';
import 'package:safqaseller/features/profile/view_model/profile_view_model_state.dart';

class EditAccountView extends StatelessWidget {
  const EditAccountView({super.key, this.profile});

  static const String routeName = 'editAccountView';

  final ProfileLoaded? profile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EditAccountViewModel>(),
      child: EditAccountViewBody(profile: profile),
    );
  }
}
