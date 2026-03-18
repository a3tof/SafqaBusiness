import 'package:flutter/material.dart';
import 'package:safqaseller/features/adaptive_layout/view/adaptive_layout_view.dart';
import 'package:safqaseller/features/adaptive_layout/view/widgets/desktop_layout.dart';
import 'package:safqaseller/features/adaptive_layout/view/widgets/mobile_layout.dart';
import 'package:safqaseller/features/adaptive_layout/view/widgets/tablet_layout.dart';
import 'package:safqaseller/features/auth/view/auth_route_args.dart';
import 'package:safqaseller/features/auth/view/create_password_view.dart';
import 'package:safqaseller/features/auth/view/forget_password_view.dart';
import 'package:safqaseller/features/auth/view/signin_view.dart';
import 'package:safqaseller/features/auth/view/signup_view.dart';
import 'package:safqaseller/features/auth/view/verification_code_view.dart';
import 'package:safqaseller/features/home/view/home_screen_view.dart';
import 'package:safqaseller/features/on_boarding/view/on_boarding_view.dart';
import 'package:safqaseller/features/splash/view/splash_screen_view.dart';
import 'package:safqaseller/features/terms_and_conditions/view/terms_and_conditions_view.dart';
import 'package:safqaseller/features/wallet/view/add_card_view.dart';
import 'package:safqaseller/features/wallet/view/deposit_view.dart';
import 'package:safqaseller/features/wallet/view/saved_cards_view.dart';
import 'package:safqaseller/features/wallet/view/transaction_history_view.dart';
import 'package:safqaseller/features/wallet/view/wallet_view.dart';
import 'package:safqaseller/features/wallet/view/withdrawal_view.dart';

Route<dynamic> onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    // ── Adaptive layout ────────────────────────────────────────────────────
    case TabletLayout.routeName:
      return MaterialPageRoute(builder: (_) => const TabletLayout());
    case DesktopLayout.routeName:
      return MaterialPageRoute(builder: (_) => const DesktopLayout());
    case AdaptiveLayoutView.routeName:
      return MaterialPageRoute(builder: (_) => const AdaptiveLayoutView());
    case MobileLayout.routeName:
      return MaterialPageRoute(builder: (_) => const MobileLayout());

    // ── Auth ───────────────────────────────────────────────────────────────
    case SigninView.routeName:
      return MaterialPageRoute(builder: (_) => const SigninView());
    case SignupView.routeName:
      return MaterialPageRoute(builder: (_) => const SignupView());
    case ForgotPasswordView.routeName:
      return MaterialPageRoute(builder: (_) => const ForgotPasswordView());
    case VerificationCodeView.routeName:
      final args = settings.arguments as VerificationCodeArgs;
      return MaterialPageRoute(
          builder: (_) => VerificationCodeView(args: args));
    case CreatePasswordView.routeName:
      final args = settings.arguments as CreatePasswordArgs;
      return MaterialPageRoute(
          builder: (_) => CreatePasswordView(args: args));

    // ── Core screens ───────────────────────────────────────────────────────
    case SplashView.routeName:
      return MaterialPageRoute(builder: (_) => const SplashView());
    case OnBoardingView.routeName:
      return MaterialPageRoute(builder: (_) => const OnBoardingView());
    case HomeScreenView.routeName:
      return MaterialPageRoute(builder: (_) => const HomeScreenView());
    case TermsAndConditionsView.routeName:
      return MaterialPageRoute(
          builder: (_) => const TermsAndConditionsView());

    // ── Wallet ─────────────────────────────────────────────────────────────
    case WalletView.routeName:
      return MaterialPageRoute(builder: (_) => const WalletView());
    case SavedCardsView.routeName:
      return MaterialPageRoute(builder: (_) => const SavedCardsView());
    case AddCardView.routeName:
      return MaterialPageRoute(builder: (_) => const AddCardView());
    case DepositView.routeName:
      return MaterialPageRoute(builder: (_) => const DepositView());
    case WithdrawalView.routeName:
      return MaterialPageRoute(builder: (_) => const WithdrawalView());
    case TransactionHistoryView.routeName:
      return MaterialPageRoute(
          builder: (_) => const TransactionHistoryView());

    default:
      return MaterialPageRoute(builder: (_) => const SplashView());
  }
}
