import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/core/responsive/breakpoints.dart';
import 'package:safqaseller/core/widgets/responsive_form_widgets.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';
import 'package:safqaseller/features/auth/view_model/auth/auth_view_model.dart';
import 'package:safqaseller/features/auth/view_model/auth/auth_view_model_state.dart';
import 'package:safqaseller/features/home/view/home_screen_view.dart';
import 'package:safqaseller/features/seller/view_model/seller_view_model.dart';
import 'package:safqaseller/features/seller/view_model/seller_view_model_state.dart';

class SellerHomeView extends StatelessWidget {
  const SellerHomeView({super.key});
  static const String routeName = 'sellerHomeView';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SellerViewModel>()..getSellerHome(),
      child: _SellerHomeBody(),
    );
  }
}

class _SellerHomeBody extends StatelessWidget {
  const _SellerHomeBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<SellerViewModel, SellerViewModelState>(
          builder: (context, state) {
            if (state is SellerLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            }

            if (state is SellerError) {
              final isTabletOrUp = Breakpoints.isTabletOrUp(context);
              return Center(
                child: Padding(
                  padding: EdgeInsets.all((isTabletOrUp ? 24.0 : 24.rSp(context))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: Colors.red.shade400,
                        size: (isTabletOrUp ? 48.0 : 48.rSp(context)),
                      ),
                      SizedBox(height: (isTabletOrUp ? 16.0 : 16.rSp(context))),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyles.regular16(context)
                            .copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                      ),
                      SizedBox(height: (isTabletOrUp ? 24.0 : 24.rSp(context))),
                      TextButton(
                        onPressed: () {
                          context.read<SellerViewModel>().getSellerHome();
                        },
                        child: Text(
                          'Retry',
                          style: TextStyles.semiBold16(context)
                              .copyWith(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is SellerHomeLoaded) {
              final data = state.data;
              final isTabletOrUp = Breakpoints.isTabletOrUp(context);
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: (isTabletOrUp ? 16.0 : 16.rSp(context)), vertical: (isTabletOrUp ? 24.0 : 24.rSp(context))),
                  child: ResponsiveFormShell(
                    enabled: isTabletOrUp,
                    maxWidth: 700,
                    child: ResponsiveFormSection(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: (isTabletOrUp ? 16.0 : 16.rSp(context))),
                          // Logo + Store Name header
                          Center(
                            child: Column(
                              children: [
                                _StoreLogo(logoBase64: data.storeLogo),
                                SizedBox(height: (isTabletOrUp ? 12.0 : 12.rSp(context))),
                                Text(
                                  data.storeName,
                                  style: TextStyles.bold22(context)
                                      .copyWith(color: Theme.of(context).colorScheme.primary),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: (isTabletOrUp ? 32.0 : 32.rSp(context))),
                          // Welcome content
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to your store!',
                                style: TextStyles.semiBold20(context)
                                    .copyWith(color: Theme.of(context).colorScheme.primary),
                              ),
                              SizedBox(height: (isTabletOrUp ? 8.0 : 8.rSp(context))),
                              Text(
                                'Your seller account is active. Start managing your auctions and products from here.',
                                style: TextStyles.regular14(context).copyWith(
                                  color: Theme.of(context).hintColor,
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: (isTabletOrUp ? 24.0 : 24.rSp(context))),
                              SizedBox(
                                width: double.infinity,
                                height: (isTabletOrUp ? 54.0 : 54.rSp(context)),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      HomeScreenView.routeName,
                                      (route) => false,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14.rSp(context)),
                                    ),
                                  ),
                                  child: Text(
                                    'Go to Home',
                                    style: TextStyles.semiBold16(context)
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: (isTabletOrUp ? 32.0 : 32.rSp(context))),
                          // Logout hint
                          BlocBuilder<AuthViewModel, AuthViewModelState>(
                            builder: (context, authState) {
                              return Text(
                                authState is AuthAuthenticated
                                    ? 'Logged in as: ${authState.role}'
                                    : '',
                                textAlign: TextAlign.center,
                                style: TextStyles.regular12(context)
                                    .copyWith(color: Theme.of(context).hintColor),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _StoreLogo extends StatelessWidget {
  const _StoreLogo({this.logoBase64});

  final String? logoBase64;

  @override
  Widget build(BuildContext context) {
    Widget child;

    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    if (logoBase64 != null && logoBase64!.isNotEmpty) {
      try {
        final bytes = base64Decode(logoBase64!);
        child = ClipRRect(
          borderRadius: BorderRadius.circular((isTabletOrUp ? 40.0 : 40.rSp(context))),
          child: Image.memory(
            bytes,
            width: (isTabletOrUp ? 80.0 : 80.rSp(context)),
            height: (isTabletOrUp ? 80.0 : 80.rSp(context)),
            fit: BoxFit.cover,
          ),
        );
      } catch (_) {
        child = _defaultLogo(context);
      }
    } else {
      child = _defaultLogo(context);
    }

    return child;
  }

  Widget _defaultLogo(BuildContext context) {
    final isTabletOrUp = Breakpoints.isTabletOrUp(context);
    return Container(
      width: (isTabletOrUp ? 80.0 : 80.rSp(context)),
      height: (isTabletOrUp ? 80.0 : 80.rSp(context)),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.secondary,
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1.5,
        ),
      ),
      child: Icon(
        Icons.storefront_rounded,
        color: Theme.of(context).colorScheme.primary,
        size: (isTabletOrUp ? 40.0 : 40.rSp(context)),
      ),
    );
  }
}
