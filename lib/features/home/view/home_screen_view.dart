import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/features/home/view/widgets/home_screen_view_body.dart';
import 'package:safqaseller/features/home/view_model/home_view_model.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({
    super.key,
    this.showCompleteProfile = false,
  });
  static const String routeName = 'homeScreenView';

  final bool showCompleteProfile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<HomeViewModel>()..loadHomeData(),
      child: HomeScreenViewBody(
        showCompleteProfile: showCompleteProfile,
      ),
    );
  }
}
