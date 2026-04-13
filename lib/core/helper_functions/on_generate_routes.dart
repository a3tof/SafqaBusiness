import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/features/adaptive_layout/view/adaptive_layout_view.dart';
import 'package:safqaseller/features/adaptive_layout/view/widgets/desktop_layout.dart';
import 'package:safqaseller/features/adaptive_layout/view/widgets/mobile_layout.dart';
import 'package:safqaseller/features/adaptive_layout/view/widgets/tablet_layout.dart';
import 'package:safqaseller/features/auction/view/item_auction_view.dart';
import 'package:safqaseller/features/auction/view/lot_auction_view.dart';
import 'package:safqaseller/features/auction/view/edit_auction_view.dart';
import 'package:safqaseller/features/auction/view/lot_detail_route_args.dart';
import 'package:safqaseller/features/auction/view/lot_detail_view.dart';
import 'package:safqaseller/features/auction/view/price_duration_view.dart';
import 'package:safqaseller/features/auction/view_model/create_auction/create_auction_view_model.dart';
import 'package:safqaseller/features/auth/view/auth_route_args.dart';
import 'package:safqaseller/features/auth/view/create_password_view.dart';
import 'package:safqaseller/features/auth/view/forget_password_view.dart';
import 'package:safqaseller/features/auth/view/signin_view.dart';
import 'package:safqaseller/features/auth/view/signup_view.dart';
import 'package:safqaseller/features/auth/view/verification_code_view.dart';
import 'package:safqaseller/features/home/view/home_screen_view.dart';
import 'package:safqaseller/features/on_boarding/view/on_boarding_view.dart';
import 'package:safqaseller/features/complete_profile/view/account_type_view.dart';
import 'package:safqaseller/features/complete_profile/view/financial_details_view.dart';
import 'package:safqaseller/features/complete_profile/view/identity_verification_view.dart';
import 'package:safqaseller/features/complete_profile/view/legal_documents_view.dart';
import 'package:safqaseller/features/complete_profile/view/seller_information_view.dart';
import 'package:safqaseller/features/complete_profile/view/store_information_view.dart';
import 'package:safqaseller/features/change_password/view/change_password_view.dart';
import 'package:safqaseller/features/chat/view/chat_list_view.dart';
import 'package:safqaseller/features/chat/view/chat_thread_view.dart';
import 'package:safqaseller/features/chat/view/chat_thread_view_args.dart';
import 'package:safqaseller/features/history/view/history_view.dart';
import 'package:safqaseller/features/profile/view/edit_account_view.dart';
import 'package:safqaseller/features/profile/view/profile_view.dart';
import 'package:safqaseller/features/profile/view_model/profile_view_model_state.dart';
import 'package:safqaseller/features/seller/view/seller_home_view.dart';
import 'package:safqaseller/features/splash/view/splash_screen_view.dart';
import 'package:safqaseller/features/subscription/view/subscription_view.dart';
import 'package:safqaseller/features/terms_and_conditions/view/terms_and_conditions_view.dart';
import 'package:safqaseller/features/notifications/view/notifications_view.dart';
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
        builder: (_) => VerificationCodeView(args: args),
      );
    case CreatePasswordView.routeName:
      final args = settings.arguments as CreatePasswordArgs;
      return MaterialPageRoute(builder: (_) => CreatePasswordView(args: args));

    // ── Core screens ───────────────────────────────────────────────────────
    case SplashView.routeName:
      return MaterialPageRoute(builder: (_) => const SplashView());
    case OnBoardingView.routeName:
      return MaterialPageRoute(builder: (_) => const OnBoardingView());
    case HomeScreenView.routeName:
      final args = settings.arguments;
      final showCompleteProfile =
          args is Map && args['showCompleteProfile'] == true;
      return MaterialPageRoute(
        builder: (_) =>
            HomeScreenView(showCompleteProfile: showCompleteProfile),
      );
    case TermsAndConditionsView.routeName:
      return MaterialPageRoute(builder: (_) => const TermsAndConditionsView());

    // ── Profile ────────────────────────────────────────────────────────────
    case ProfileView.routeName:
      return MaterialPageRoute(builder: (_) => const ProfileView());
    case EditAccountView.routeName:
      final args = settings.arguments;
      return MaterialPageRoute(
        builder: (_) =>
            EditAccountView(profile: args is ProfileLoaded ? args : null),
      );
    case HistoryView.routeName:
      return MaterialPageRoute(builder: (_) => const HistoryView());
    case ChangePasswordView.routeName:
      return MaterialPageRoute(builder: (_) => const ChangePasswordView());
    case ChatListView.routeName:
      return MaterialPageRoute(builder: (_) => const ChatListView());
    case ChatThreadView.routeName:
      final args = settings.arguments as ChatThreadViewArgs;
      return MaterialPageRoute(builder: (_) => ChatThreadView(args: args));

    // ── Auction ────────────────────────────────────────────────────────────
    case LotAuctionView.routeName:
      return MaterialPageRoute(builder: (_) => const LotAuctionView());
    case ItemAuctionView.routeName:
      return MaterialPageRoute(builder: (_) => const ItemAuctionView());
    case PriceDurationView.routeName:
      final cubit = settings.arguments;
      if (cubit is CreateAuctionViewModel) {
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: const PriceDurationView(),
          ),
        );
      }
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<CreateAuctionViewModel>(),
          child: const PriceDurationView(),
        ),
      );
    case LotDetailView.routeName:
      final args = settings.arguments as LotDetailRouteArgs?;
      if (args == null) {
        return MaterialPageRoute(builder: (_) => const HistoryView());
      }
      return MaterialPageRoute(builder: (_) => LotDetailView(args: args));
    case EditAuctionView.routeName:
      final args = settings.arguments as LotDetailRouteArgs?;
      if (args == null) {
        return MaterialPageRoute(builder: (_) => const HistoryView());
      }
      return MaterialPageRoute(builder: (_) => EditAuctionView(args: args));

    // ── Complete Profile ───────────────────────────────────────────────────
    case AccountTypeView.routeName:
      return MaterialPageRoute(builder: (_) => const AccountTypeView());
    case SellerInformationView.routeName:
      final args = settings.arguments;
      return MaterialPageRoute(
        builder: (_) => SellerInformationView(accountType: args),
      );
    case IdentityVerificationView.routeName:
      final isBusinessFlow = settings.arguments == true;
      return MaterialPageRoute(
        builder: (_) =>
            IdentityVerificationView(isBusinessFlow: isBusinessFlow),
      );
    case StoreInformationView.routeName:
      return MaterialPageRoute(builder: (_) => const StoreInformationView());
    case LegalDocumentsView.routeName:
      return MaterialPageRoute(builder: (_) => const LegalDocumentsView());
    case FinancialDetailsView.routeName:
      final args = settings.arguments as LegalDocumentsArgs?;
      return MaterialPageRoute(
        builder: (_) => FinancialDetailsView(legalDocs: args),
      );

    // ── Seller Home ────────────────────────────────────────────────────────
    case SellerHomeView.routeName:
      return MaterialPageRoute(builder: (_) => const SellerHomeView());

    // ── Wallet ─────────────────────────────────────────────────────────────
    case WalletView.routeName:
      return MaterialPageRoute(builder: (_) => const WalletView());
    case SavedCardsView.routeName:
      return MaterialPageRoute(builder: (_) => const SavedCardsView());
    case AddCardView.routeName:
      return MaterialPageRoute(builder: (_) => const AddCardView());
    case DepositView.routeName:
      return MaterialPageRoute(builder: (_) => const DepositView());
    case SubscriptionView.routeName:
      return MaterialPageRoute(builder: (_) => const SubscriptionView());
    case WithdrawalView.routeName:
      return MaterialPageRoute(builder: (_) => const WithdrawalView());
    case TransactionHistoryView.routeName:
      return MaterialPageRoute(builder: (_) => const TransactionHistoryView());

    // ── Notifications ──────────────────────────────────────────────────────
    case NotificationsView.routeName:
      return MaterialPageRoute(builder: (_) => const NotificationsView());

    default:
      return MaterialPageRoute(builder: (_) => const SplashView());
  }
}
