import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/widgets/custom_app_bar.dart';
import 'package:safqaseller/features/auth/view/signin_view.dart';
import 'package:safqaseller/features/auth/view_model/logout/logout_view_model.dart';
import 'package:safqaseller/features/auth/view_model/logout/logout_view_model_state.dart';
import 'package:safqaseller/features/profile/view/widgets/profile_view_body.dart';
import 'package:safqaseller/generated/l10n.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  static const String routeName = 'profile';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LogoutViewModel>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context: context, title: S.of(context).kBusinessAccount),
        body: BlocConsumer<LogoutViewModel, LogoutState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                SigninView.routeName,
                (route) => false,
              );
            } else if (state is LogoutError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is LogoutLoading) {
              return Stack(
                children: [
                  const ProfileViewBody(),
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              );
            }
            return const ProfileViewBody();
          },
        ),
      ),
    );
  }
}
