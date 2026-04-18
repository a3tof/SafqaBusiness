// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `This field is required`
  String get fieldRequired {
    return Intl.message(
      'This field is required',
      name: 'fieldRequired',
      desc: 'Validation message when a required field is empty',
      args: [],
    );
  }

  /// `Log In`
  String get logIn {
    return Intl.message(
      'Log In',
      name: 'logIn',
      desc: 'Log in button label',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: 'Sign up button label',
      args: [],
    );
  }

  /// `Stop wasting time!`
  String get onBoardingTitle1 {
    return Intl.message(
      'Stop wasting time!',
      name: 'onBoardingTitle1',
      desc: 'Onboarding page 1 title',
      args: [],
    );
  }

  /// `Safqa transforms the long auction process into a fast, guaranteed digital experience, manage your auctions wherever you are.`
  String get onBoardingSubtitle1 {
    return Intl.message(
      'Safqa transforms the long auction process into a fast, guaranteed digital experience, manage your auctions wherever you are.',
      name: 'onBoardingSubtitle1',
      desc: 'Onboarding page 1 subtitle',
      args: [],
    );
  }

  /// `Smart Bidding`
  String get onBoardingTitle2 {
    return Intl.message(
      'Smart Bidding',
      name: 'onBoardingTitle2',
      desc: 'Onboarding page 2 title',
      args: [],
    );
  }

  /// `Participate in real-time bidding, or let the Proxy Bidding (Auto-Bid) system win automatically within your defined limit.`
  String get onBoardingSubtitle2 {
    return Intl.message(
      'Participate in real-time bidding, or let the Proxy Bidding (Auto-Bid) system win automatically within your defined limit.',
      name: 'onBoardingSubtitle2',
      desc: 'Onboarding page 2 subtitle',
      args: [],
    );
  }

  /// `Experience Designed For You`
  String get onBoardingTitle3 {
    return Intl.message(
      'Experience Designed For You',
      name: 'onBoardingTitle3',
      desc: 'Onboarding page 3 title',
      args: [],
    );
  }

  /// `A modern, bilingual (Arabic/English) design that allows you to navigate and bid seamlessly from any device.`
  String get onBoardingSubtitle3 {
    return Intl.message(
      'A modern, bilingual (Arabic/English) design that allows you to navigate and bid seamlessly from any device.',
      name: 'onBoardingSubtitle3',
      desc: 'Onboarding page 3 subtitle',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: 'Sign in button label',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: 'Email field label',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: 'Password field label',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: 'Forgot password link label',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get signInWithGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'signInWithGoogle',
      desc: 'Sign in with Google button label',
      args: [],
    );
  }

  /// `Sign in with Apple`
  String get signInWithApple {
    return Intl.message(
      'Sign in with Apple',
      name: 'signInWithApple',
      desc: 'Sign in with Apple button label',
      args: [],
    );
  }

  /// `Sign in with Facebook`
  String get signInWithFacebook {
    return Intl.message(
      'Sign in with Facebook',
      name: 'signInWithFacebook',
      desc: 'Sign in with Facebook button label',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: 'Full name field label',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: 'Phone number field label',
      args: [],
    );
  }

  /// `Birthdate`
  String get birthdate {
    return Intl.message(
      'Birthdate',
      name: 'birthdate',
      desc: 'Birthdate field label',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: 'Gender field label',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: 'Male gender option',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: 'Female gender option',
      args: [],
    );
  }

  /// `OTP sent to your email`
  String get otpSentToEmail {
    return Intl.message(
      'OTP sent to your email',
      name: 'otpSentToEmail',
      desc: 'Message shown when OTP is sent to email',
      args: [],
    );
  }

  /// `By signing up, you agree to our`
  String get termsAndConditionsPrefix {
    return Intl.message(
      'By signing up, you agree to our',
      name: 'termsAndConditionsPrefix',
      desc: 'Prefix text before terms and conditions link',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get termsAndConditions {
    return Intl.message(
      'Terms and Conditions',
      name: 'termsAndConditions',
      desc: 'Terms and conditions link label',
      args: [],
    );
  }

  /// `Or`
  String get or {
    return Intl.message(
      'Or',
      name: 'or',
      desc: 'Divider text between sign in options',
      args: [],
    );
  }

  /// `Already have an account?`
  String get haveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'haveAccount',
      desc: 'Text shown when user already has an account',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: 'Text shown when user does not have an account',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: 'Create account button label',
      args: [],
    );
  }

  /// `Verification Code`
  String get verificationCode {
    return Intl.message(
      'Verification Code',
      name: 'verificationCode',
      desc: 'Verification code screen title',
      args: [],
    );
  }

  /// `Enter the verification code sent to your email`
  String get verificationCodeDescription {
    return Intl.message(
      'Enter the verification code sent to your email',
      name: 'verificationCodeDescription',
      desc: 'Verification code screen description',
      args: [],
    );
  }

  /// `Email confirmed successfully`
  String get emailConfirmedSuccessfully {
    return Intl.message(
      'Email confirmed successfully',
      name: 'emailConfirmedSuccessfully',
      desc: 'Message shown when email is confirmed successfully',
      args: [],
    );
  }

  /// `OTP resent successfully`
  String get otpResentSuccessfully {
    return Intl.message(
      'OTP resent successfully',
      name: 'otpResentSuccessfully',
      desc: 'Message shown when OTP is resent successfully',
      args: [],
    );
  }

  /// `OTP has expired`
  String get otpExpired {
    return Intl.message(
      'OTP has expired',
      name: 'otpExpired',
      desc: 'Message shown when OTP has expired',
      args: [],
    );
  }

  /// `Invalid OTP`
  String get invalidOtp {
    return Intl.message(
      'Invalid OTP',
      name: 'invalidOtp',
      desc: 'Message shown when OTP is invalid',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: 'Verify button label',
      args: [],
    );
  }

  /// `Didn't receive a code?`
  String get dontReceiveCode {
    return Intl.message(
      'Didn\'t receive a code?',
      name: 'dontReceiveCode',
      desc: 'Text shown when user did not receive verification code',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message(
      'Resend',
      name: 'resend',
      desc: 'Resend button label',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgetPasswordTitle {
    return Intl.message(
      'Forgot Password',
      name: 'forgetPasswordTitle',
      desc: 'Forgot password screen title',
      args: [],
    );
  }

  /// `Enter your email address and we'll send you a code to reset your password`
  String get forgetPasswordDescription {
    return Intl.message(
      'Enter your email address and we\'ll send you a code to reset your password',
      name: 'forgetPasswordDescription',
      desc: 'Forgot password screen description',
      args: [],
    );
  }

  /// `Send Code`
  String get sendCode {
    return Intl.message(
      'Send Code',
      name: 'sendCode',
      desc: 'Send code button label',
      args: [],
    );
  }

  /// `Create Password`
  String get createPassword {
    return Intl.message(
      'Create Password',
      name: 'createPassword',
      desc: 'Create password screen title and button label',
      args: [],
    );
  }

  /// `Create a new password for your account`
  String get createPasswordDescription {
    return Intl.message(
      'Create a new password for your account',
      name: 'createPasswordDescription',
      desc: 'Create password screen description',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: 'New password field label',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: 'Confirm password field label',
      args: [],
    );
  }

  /// `Password reset successfully`
  String get passwordResetSuccessfully {
    return Intl.message(
      'Password reset successfully',
      name: 'passwordResetSuccessfully',
      desc: 'Message shown when password is reset successfully',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: 'Validation message when passwords do not match',
      args: [],
    );
  }

  /// `All users must comply with the platform's rules and regulations at all times.`
  String get termsPlatformCompliance {
    return Intl.message(
      'All users must comply with the platform\'s rules and regulations at all times.',
      name: 'termsPlatformCompliance',
      desc: 'Terms: platform compliance paragraph',
      args: [],
    );
  }

  /// `Users are required to provide accurate and truthful information when using the platform.`
  String get termsAccurateInfo {
    return Intl.message(
      'Users are required to provide accurate and truthful information when using the platform.',
      name: 'termsAccurateInfo',
      desc: 'Terms: accurate info paragraph',
      args: [],
    );
  }

  /// `Safqa reserves the right to suspend or terminate accounts that violate these terms.`
  String get termsSuspendAccounts {
    return Intl.message(
      'Safqa reserves the right to suspend or terminate accounts that violate these terms.',
      name: 'termsSuspendAccounts',
      desc: 'Terms: suspend accounts paragraph',
      args: [],
    );
  }

  /// `All activities on the platform are monitored to ensure compliance and security.`
  String get termsMonitored {
    return Intl.message(
      'All activities on the platform are monitored to ensure compliance and security.',
      name: 'termsMonitored',
      desc: 'Terms: monitored paragraph',
      args: [],
    );
  }

  /// `Buyer Application`
  String get termsBuyerAppTitle {
    return Intl.message(
      'Buyer Application',
      name: 'termsBuyerAppTitle',
      desc: 'Terms: buyer app section title',
      args: [],
    );
  }

  /// `Account Usage`
  String get termsAccountUsageTitle {
    return Intl.message(
      'Account Usage',
      name: 'termsAccountUsageTitle',
      desc: 'Terms: account usage section title',
      args: [],
    );
  }

  /// `Buyers must be at least 18 years of age to create an account and participate in auctions.`
  String get termsBuyerAge {
    return Intl.message(
      'Buyers must be at least 18 years of age to create an account and participate in auctions.',
      name: 'termsBuyerAge',
      desc: 'Terms: buyer age paragraph',
      args: [],
    );
  }

  /// `Buyers are responsible for maintaining the confidentiality of their account credentials.`
  String get termsBuyerCredentials {
    return Intl.message(
      'Buyers are responsible for maintaining the confidentiality of their account credentials.',
      name: 'termsBuyerCredentials',
      desc: 'Terms: buyer credentials paragraph',
      args: [],
    );
  }

  /// `Creating multiple accounts for the same individual is strictly prohibited.`
  String get termsBuyerMultipleAccounts {
    return Intl.message(
      'Creating multiple accounts for the same individual is strictly prohibited.',
      name: 'termsBuyerMultipleAccounts',
      desc: 'Terms: buyer multiple accounts paragraph',
      args: [],
    );
  }

  /// `Bidding Rules`
  String get termsBiddingRulesTitle {
    return Intl.message(
      'Bidding Rules',
      name: 'termsBiddingRulesTitle',
      desc: 'Terms: bidding rules section title',
      args: [],
    );
  }

  /// `All bids placed on the platform are legally binding and cannot be retracted.`
  String get termsBindingBids {
    return Intl.message(
      'All bids placed on the platform are legally binding and cannot be retracted.',
      name: 'termsBindingBids',
      desc: 'Terms: binding bids paragraph',
      args: [],
    );
  }

  /// `The highest bid at the close of the auction wins the item.`
  String get termsHighestBidWins {
    return Intl.message(
      'The highest bid at the close of the auction wins the item.',
      name: 'termsHighestBidWins',
      desc: 'Terms: highest bid wins paragraph',
      args: [],
    );
  }

  /// `Proxy bidding allows the system to automatically bid on your behalf up to your maximum limit.`
  String get termsProxyBiddingRules {
    return Intl.message(
      'Proxy bidding allows the system to automatically bid on your behalf up to your maximum limit.',
      name: 'termsProxyBiddingRules',
      desc: 'Terms: proxy bidding rules paragraph',
      args: [],
    );
  }

  /// `Any attempt to manipulate bids or collude with other bidders is strictly prohibited.`
  String get termsManipulateBids {
    return Intl.message(
      'Any attempt to manipulate bids or collude with other bidders is strictly prohibited.',
      name: 'termsManipulateBids',
      desc: 'Terms: manipulate bids paragraph',
      args: [],
    );
  }

  /// `Payments`
  String get termsPaymentsTitle {
    return Intl.message(
      'Payments',
      name: 'termsPaymentsTitle',
      desc: 'Terms: payments section title',
      args: [],
    );
  }

  /// `Buyers must maintain sufficient wallet balance to cover their bids and purchases.`
  String get termsWalletBalance {
    return Intl.message(
      'Buyers must maintain sufficient wallet balance to cover their bids and purchases.',
      name: 'termsWalletBalance',
      desc: 'Terms: wallet balance paragraph',
      args: [],
    );
  }

  /// `Security deposits may be required for certain high-value auctions.`
  String get termsSecurityDeposits {
    return Intl.message(
      'Security deposits may be required for certain high-value auctions.',
      name: 'termsSecurityDeposits',
      desc: 'Terms: security deposits paragraph',
      args: [],
    );
  }

  /// `Refunds are processed within 7 business days after a valid dispute is resolved in the buyer's favor.`
  String get termsRefundsPolicy {
    return Intl.message(
      'Refunds are processed within 7 business days after a valid dispute is resolved in the buyer\'s favor.',
      name: 'termsRefundsPolicy',
      desc: 'Terms: refunds policy paragraph',
      args: [],
    );
  }

  /// `Disputes`
  String get termsDisputesTitle {
    return Intl.message(
      'Disputes',
      name: 'termsDisputesTitle',
      desc: 'Terms: disputes section title',
      args: [],
    );
  }

  /// `Buyers may raise a dispute within 48 hours of receiving an item that does not match the description.`
  String get termsRaiseDisputes {
    return Intl.message(
      'Buyers may raise a dispute within 48 hours of receiving an item that does not match the description.',
      name: 'termsRaiseDisputes',
      desc: 'Terms: raise disputes paragraph',
      args: [],
    );
  }

  /// `Safqa's dispute resolution team will review all submitted evidence and make a final decision.`
  String get termsDisputeDecisions {
    return Intl.message(
      'Safqa\'s dispute resolution team will review all submitted evidence and make a final decision.',
      name: 'termsDisputeDecisions',
      desc: 'Terms: dispute decisions paragraph',
      args: [],
    );
  }

  /// `Seller Application`
  String get termsSellerAppTitle {
    return Intl.message(
      'Seller Application',
      name: 'termsSellerAppTitle',
      desc: 'Terms: seller app section title',
      args: [],
    );
  }

  /// `Seller Registration`
  String get termsSellerRegTitle {
    return Intl.message(
      'Seller Registration',
      name: 'termsSellerRegTitle',
      desc: 'Terms: seller registration section title',
      args: [],
    );
  }

  /// `All sellers must complete identity verification before listing items for auction.`
  String get termsSellerVerification {
    return Intl.message(
      'All sellers must complete identity verification before listing items for auction.',
      name: 'termsSellerVerification',
      desc: 'Terms: seller verification paragraph',
      args: [],
    );
  }

  /// `Seller accounts are subject to approval by the Safqa team before becoming active.`
  String get termsSellerApproval {
    return Intl.message(
      'Seller accounts are subject to approval by the Safqa team before becoming active.',
      name: 'termsSellerApproval',
      desc: 'Terms: seller approval paragraph',
      args: [],
    );
  }

  /// `Sellers are responsible for the accuracy and completeness of their product listings.`
  String get termsSellerAccuracy {
    return Intl.message(
      'Sellers are responsible for the accuracy and completeness of their product listings.',
      name: 'termsSellerAccuracy',
      desc: 'Terms: seller accuracy paragraph',
      args: [],
    );
  }

  /// `Auction Management`
  String get termsAuctionMgmtTitle {
    return Intl.message(
      'Auction Management',
      name: 'termsAuctionMgmtTitle',
      desc: 'Terms: auction management section title',
      args: [],
    );
  }

  /// `Sellers must provide honest and accurate descriptions of all items listed for auction.`
  String get termsHonestDescriptions {
    return Intl.message(
      'Sellers must provide honest and accurate descriptions of all items listed for auction.',
      name: 'termsHonestDescriptions',
      desc: 'Terms: honest descriptions paragraph',
      args: [],
    );
  }

  /// `Sellers must adhere to all platform auction rules, including minimum pricing guidelines.`
  String get termsAuctionRules {
    return Intl.message(
      'Sellers must adhere to all platform auction rules, including minimum pricing guidelines.',
      name: 'termsAuctionRules',
      desc: 'Terms: auction rules paragraph',
      args: [],
    );
  }

  /// `Active auction listings cannot be modified once bidding has commenced.`
  String get termsNoModifyActive {
    return Intl.message(
      'Active auction listings cannot be modified once bidding has commenced.',
      name: 'termsNoModifyActive',
      desc: 'Terms: no modify active paragraph',
      args: [],
    );
  }

  /// `Delivery`
  String get termsDeliveryTitle {
    return Intl.message(
      'Delivery',
      name: 'termsDeliveryTitle',
      desc: 'Terms: delivery section title',
      args: [],
    );
  }

  /// `Sellers are obligated to deliver items to winning buyers within the agreed timeframe.`
  String get termsTimelyDelivery {
    return Intl.message(
      'Sellers are obligated to deliver items to winning buyers within the agreed timeframe.',
      name: 'termsTimelyDelivery',
      desc: 'Terms: timely delivery paragraph',
      args: [],
    );
  }

  /// `Accurate delivery information must be provided to ensure smooth and timely shipments.`
  String get termsDeliveryInfo {
    return Intl.message(
      'Accurate delivery information must be provided to ensure smooth and timely shipments.',
      name: 'termsDeliveryInfo',
      desc: 'Terms: delivery info paragraph',
      args: [],
    );
  }

  /// `Failure to deliver items may result in account suspension and financial penalties.`
  String get termsFailureToDeliver {
    return Intl.message(
      'Failure to deliver items may result in account suspension and financial penalties.',
      name: 'termsFailureToDeliver',
      desc: 'Terms: failure to deliver paragraph',
      args: [],
    );
  }

  /// `Fees`
  String get termsFeesTitle {
    return Intl.message(
      'Fees',
      name: 'termsFeesTitle',
      desc: 'Terms: fees section title',
      args: [],
    );
  }

  /// `Safqa charges a platform fee on all successfully completed auction transactions.`
  String get termsPlatformFees {
    return Intl.message(
      'Safqa charges a platform fee on all successfully completed auction transactions.',
      name: 'termsPlatformFees',
      desc: 'Terms: platform fees paragraph',
      args: [],
    );
  }

  /// `Sellers can track their earnings and fee deductions in real time through the seller dashboard.`
  String get termsTrackEarnings {
    return Intl.message(
      'Sellers can track their earnings and fee deductions in real time through the seller dashboard.',
      name: 'termsTrackEarnings',
      desc: 'Terms: track earnings paragraph',
      args: [],
    );
  }

  /// `Notification Policy`
  String get termsNotifPolicyTitle {
    return Intl.message(
      'Notification Policy',
      name: 'termsNotifPolicyTitle',
      desc: 'Terms: notification policy section title',
      args: [],
    );
  }

  /// `Notifications are automatically generated for key events such as new bids, auction endings, and payments.`
  String get termsNotifGenerated {
    return Intl.message(
      'Notifications are automatically generated for key events such as new bids, auction endings, and payments.',
      name: 'termsNotifGenerated',
      desc: 'Terms: notifications generated paragraph',
      args: [],
    );
  }

  /// `Notifications are for informational purposes only and do not constitute legal or financial advice.`
  String get termsNotifInformational {
    return Intl.message(
      'Notifications are for informational purposes only and do not constitute legal or financial advice.',
      name: 'termsNotifInformational',
      desc: 'Terms: notifications informational paragraph',
      args: [],
    );
  }

  /// `Users are responsible for reviewing all notifications and taking appropriate action in a timely manner.`
  String get termsReviewNotif {
    return Intl.message(
      'Users are responsible for reviewing all notifications and taking appropriate action in a timely manner.',
      name: 'termsReviewNotif',
      desc: 'Terms: review notifications paragraph',
      args: [],
    );
  }

  /// `Privacy & Data`
  String get termsPrivacyDataTitle {
    return Intl.message(
      'Privacy & Data',
      name: 'termsPrivacyDataTitle',
      desc: 'Terms: privacy and data section title',
      args: [],
    );
  }

  /// `Safqa collects personal data including name, email, phone number, and transaction history.`
  String get termsDataCollected {
    return Intl.message(
      'Safqa collects personal data including name, email, phone number, and transaction history.',
      name: 'termsDataCollected',
      desc: 'Terms: data collected paragraph',
      args: [],
    );
  }

  /// `All collected data is stored securely and protected against unauthorized access.`
  String get termsDataProtected {
    return Intl.message(
      'All collected data is stored securely and protected against unauthorized access.',
      name: 'termsDataProtected',
      desc: 'Terms: data protected paragraph',
      args: [],
    );
  }

  /// `Safqa does not share personal user data with third parties without explicit user consent.`
  String get termsNoShareData {
    return Intl.message(
      'Safqa does not share personal user data with third parties without explicit user consent.',
      name: 'termsNoShareData',
      desc: 'Terms: no share data paragraph',
      args: [],
    );
  }

  /// `Liability`
  String get termsLiabilityTitle {
    return Intl.message(
      'Liability',
      name: 'termsLiabilityTitle',
      desc: 'Terms: liability section title',
      args: [],
    );
  }

  /// `Safqa is not responsible for losses arising from user errors or third-party service failures.`
  String get termsNotResponsible {
    return Intl.message(
      'Safqa is not responsible for losses arising from user errors or third-party service failures.',
      name: 'termsNotResponsible',
      desc: 'Terms: not responsible paragraph',
      args: [],
    );
  }

  /// `The platform may experience scheduled or unscheduled downtime for maintenance purposes.`
  String get termsDowntime {
    return Intl.message(
      'The platform may experience scheduled or unscheduled downtime for maintenance purposes.',
      name: 'termsDowntime',
      desc: 'Terms: downtime paragraph',
      args: [],
    );
  }

  /// `Safqa acts solely as an intermediary between buyers and sellers and does not guarantee transaction outcomes.`
  String get termsIntermediary {
    return Intl.message(
      'Safqa acts solely as an intermediary between buyers and sellers and does not guarantee transaction outcomes.',
      name: 'termsIntermediary',
      desc: 'Terms: intermediary paragraph',
      args: [],
    );
  }

  /// `Changes to Terms`
  String get termsChangesTitle {
    return Intl.message(
      'Changes to Terms',
      name: 'termsChangesTitle',
      desc: 'Terms: changes to terms section title',
      args: [],
    );
  }

  /// `Safqa reserves the right to update these terms and conditions at any time without prior notice.`
  String get termsUpdatedAnytime {
    return Intl.message(
      'Safqa reserves the right to update these terms and conditions at any time without prior notice.',
      name: 'termsUpdatedAnytime',
      desc: 'Terms: updated anytime paragraph',
      args: [],
    );
  }

  /// `Continued use of the platform after any changes constitutes acceptance of the updated terms.`
  String get termsContinuedUse {
    return Intl.message(
      'Continued use of the platform after any changes constitutes acceptance of the updated terms.',
      name: 'termsContinuedUse',
      desc: 'Terms: continued use paragraph',
      args: [],
    );
  }

  /// `No previous page to navigate back to`
  String get kNoPreviousPageTo {
    return Intl.message(
      'No previous page to navigate back to',
      name: 'kNoPreviousPageTo',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Login Successful!`
  String get kLoginSuccessful {
    return Intl.message(
      'Login Successful!',
      name: 'kLoginSuccessful',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Country`
  String get kCountry {
    return Intl.message(
      'Country',
      name: 'kCountry',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `City`
  String get kCity {
    return Intl.message(
      'City',
      name: 'kCity',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Please fill all fields including City`
  String get kPleaseFillAllFiel {
    return Intl.message(
      'Please fill all fields including City',
      name: 'kPleaseFillAllFiel',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Account Type`
  String get kAccountType {
    return Intl.message(
      'Account Type',
      name: 'kAccountType',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Please select a bank`
  String get kPleaseSelectABank {
    return Intl.message(
      'Please select a bank',
      name: 'kPleaseSelectABank',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Legal documents are missing. Please go back.`
  String get kLegalDocumentsAre {
    return Intl.message(
      'Legal documents are missing. Please go back.',
      name: 'kLegalDocumentsAre',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Financial Details`
  String get kFinancialDetails {
    return Intl.message(
      'Financial Details',
      name: 'kFinancialDetails',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Insta Pay Number (Optional)`
  String get kInstaPayNumberOp {
    return Intl.message(
      'Insta Pay Number (Optional)',
      name: 'kInstaPayNumberOp',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Bank Name`
  String get kBankName {
    return Intl.message(
      'Bank Name',
      name: 'kBankName',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Account Name / Beneficiary Name`
  String get kAccountNameBenef {
    return Intl.message(
      'Account Name / Beneficiary Name',
      name: 'kAccountNameBenef',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Company IBAN`
  String get kCompanyIban {
    return Intl.message(
      'Company IBAN',
      name: 'kCompanyIban',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Local Account Number (Optional)`
  String get kLocalAccountNumber {
    return Intl.message(
      'Local Account Number (Optional)',
      name: 'kLocalAccountNumber',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Please upload all three documents`
  String get kPleaseUploadAllTh {
    return Intl.message(
      'Please upload all three documents',
      name: 'kPleaseUploadAllTh',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Identity Verification`
  String get kIdentityVerificatio {
    return Intl.message(
      'Identity Verification',
      name: 'kIdentityVerificatio',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Upload National ID (Front)`
  String get kUploadNationalId {
    return Intl.message(
      'Upload National ID (Front)',
      name: 'kUploadNationalId',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Take a Selfie with ID`
  String get kTakeASelfieWithI {
    return Intl.message(
      'Take a Selfie with ID',
      name: 'kTakeASelfieWithI',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Legal Documents`
  String get kLegalDocuments {
    return Intl.message(
      'Legal Documents',
      name: 'kLegalDocuments',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Upload Commercial Registration (CR)`
  String get kUploadCommercialRe {
    return Intl.message(
      'Upload Commercial Registration (CR)',
      name: 'kUploadCommercialRe',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Upload Tax ID`
  String get kUploadTaxId {
    return Intl.message(
      'Upload Tax ID',
      name: 'kUploadTaxId',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Upload owner's national ID (front)`
  String get kUploadOwner {
    return Intl.message(
      'Upload owner\'s national ID (front)',
      name: 'kUploadOwner',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Please upload all four documents`
  String get kPleaseUploadAllFo {
    return Intl.message(
      'Please upload all four documents',
      name: 'kPleaseUploadAllFo',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Please select a country and a city`
  String get kPleaseSelectACoun {
    return Intl.message(
      'Please select a country and a city',
      name: 'kPleaseSelectACoun',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Seller Information`
  String get kSellerInformation {
    return Intl.message(
      'Seller Information',
      name: 'kSellerInformation',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Store Name`
  String get kStoreName {
    return Intl.message(
      'Store Name',
      name: 'kStoreName',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Phone Number`
  String get kPhoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'kPhoneNumber',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Select Country`
  String get kSelectCountry {
    return Intl.message(
      'Select Country',
      name: 'kSelectCountry',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Select City`
  String get kSelectCity {
    return Intl.message(
      'Select City',
      name: 'kSelectCity',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Logo (Optional)`
  String get kLogoOptional {
    return Intl.message(
      'Logo (Optional)',
      name: 'kLogoOptional',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Description`
  String get kDescription {
    return Intl.message(
      'Description',
      name: 'kDescription',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Store Information`
  String get kStoreInformation {
    return Intl.message(
      'Store Information',
      name: 'kStoreInformation',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Legal Business Name`
  String get kLegalBusinessName {
    return Intl.message(
      'Legal Business Name',
      name: 'kLegalBusinessName',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Business Number`
  String get kBusinessNumber {
    return Intl.message(
      'Business Number',
      name: 'kBusinessNumber',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Business Address`
  String get kBusinessAddress {
    return Intl.message(
      'Business Address',
      name: 'kBusinessAddress',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Store Logo (Optional)`
  String get kStoreLogoOptional {
    return Intl.message(
      'Store Logo (Optional)',
      name: 'kStoreLogoOptional',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Store Description`
  String get kStoreDescription {
    return Intl.message(
      'Store Description',
      name: 'kStoreDescription',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `New Lot Auction`
  String get kNewLotAuction {
    return Intl.message(
      'New Lot Auction',
      name: 'kNewLotAuction',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `New Single Auction`
  String get kNewSingleAuction {
    return Intl.message(
      'New Single Auction',
      name: 'kNewSingleAuction',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `History`
  String get kHistory {
    return Intl.message(
      'History',
      name: 'kHistory',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Statistics`
  String get kStatistics {
    return Intl.message(
      'Statistics',
      name: 'kStatistics',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Opening chat...`
  String get kOpeningChat {
    return Intl.message(
      'Opening chat...',
      name: 'kOpeningChat',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Business Account`
  String get kBusinessAccount {
    return Intl.message(
      'Business Account',
      name: 'kBusinessAccount',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Upgrade`
  String get kUpgrade {
    return Intl.message(
      'Upgrade',
      name: 'kUpgrade',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Edit`
  String get kEdit {
    return Intl.message(
      'Edit',
      name: 'kEdit',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Edit account`
  String get kEditAccount {
    return Intl.message(
      'Edit account',
      name: 'kEditAccount',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Save`
  String get kSave {
    return Intl.message(
      'Save',
      name: 'kSave',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Profile updated successfully`
  String get kProfileUpdatedSuccessfully {
    return Intl.message(
      'Profile updated successfully',
      name: 'kProfileUpdatedSuccessfully',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Change profile photo`
  String get kEditAccountPhotoHint {
    return Intl.message(
      'Change profile photo',
      name: 'kEditAccountPhotoHint',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Wallet`
  String get kWallet {
    return Intl.message(
      'Wallet',
      name: 'kWallet',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Cairo, Egypt`
  String get kCairoEgypt {
    return Intl.message(
      'Cairo, Egypt',
      name: 'kCairoEgypt',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Reviews & Ratings`
  String get kReviewsRatings {
    return Intl.message(
      'Reviews & Ratings',
      name: 'kReviewsRatings',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Change Language`
  String get kChangeLanguage {
    return Intl.message(
      'Change Language',
      name: 'kChangeLanguage',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Logout`
  String get kLogout {
    return Intl.message(
      'Logout',
      name: 'kLogout',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `English`
  String get kEnglish {
    return Intl.message(
      'English',
      name: 'kEnglish',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Arabic`
  String get kArabic {
    return Intl.message(
      'Arabic',
      name: 'kArabic',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get profileLogoutDialogMessage {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'profileLogoutDialogMessage',
      desc:
          'Confirmation message shown before logging out from the profile screen',
      args: [],
    );
  }

  /// `Choose the language you want to use.`
  String get profileLanguageDialogMessage {
    return Intl.message(
      'Choose the language you want to use.',
      name: 'profileLanguageDialogMessage',
      desc:
          'Prompt shown in the language selection dialog on the profile screen',
      args: [],
    );
  }

  /// `Deposit successful!`
  String get kDepositSuccessful {
    return Intl.message(
      'Deposit successful!',
      name: 'kDepositSuccessful',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Deposit`
  String get kDeposit {
    return Intl.message(
      'Deposit',
      name: 'kDeposit',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Enter deposit amount`
  String get kEnterDepositAmount {
    return Intl.message(
      'Enter deposit amount',
      name: 'kEnterDepositAmount',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `No saved cards`
  String get kNoSavedCards {
    return Intl.message(
      'No saved cards',
      name: 'kNoSavedCards',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Add Card`
  String get kAddCard {
    return Intl.message(
      'Add Card',
      name: 'kAddCard',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Transactions`
  String get kTransactions {
    return Intl.message(
      'Transactions',
      name: 'kTransactions',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `No transactions yet`
  String get kNoTransactionsYet {
    return Intl.message(
      'No transactions yet',
      name: 'kNoTransactionsYet',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Primary`
  String get kPrimary {
    return Intl.message(
      'Primary',
      name: 'kPrimary',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Withdrawal`
  String get kWithdrawal {
    return Intl.message(
      'Withdrawal',
      name: 'kWithdrawal',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Deposit\nmoney`
  String get kDepositNmoney {
    return Intl.message(
      'Deposit\\nmoney',
      name: 'kDepositNmoney',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Withdrawal\nmoney`
  String get kWithdrawalNmoney {
    return Intl.message(
      'Withdrawal\\nmoney',
      name: 'kWithdrawalNmoney',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Transaction History`
  String get kTransactionHistory {
    return Intl.message(
      'Transaction History',
      name: 'kTransactionHistory',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `EXPIRES`
  String get kExpires {
    return Intl.message(
      'EXPIRES',
      name: 'kExpires',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Withdrawal successful!`
  String get kWithdrawalSuccessfu {
    return Intl.message(
      'Withdrawal successful!',
      name: 'kWithdrawalSuccessfu',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Enter withdrawal amount`
  String get kEnterWithdrawalAmo {
    return Intl.message(
      'Enter withdrawal amount',
      name: 'kEnterWithdrawalAmo',
      desc: 'Auto-generated',
      args: [],
    );
  }

  /// `Upload Owner's National ID`
  String get kUploadOwners {
    return Intl.message(
      'Upload Owner\'s National ID',
      name: 'kUploadOwners',
      desc: '',
      args: [],
    );
  }

  /// `Basic`
  String get kBasic {
    return Intl.message('Basic', name: 'kBasic', desc: '', args: []);
  }

  /// `Premium`
  String get kPremium {
    return Intl.message('Premium', name: 'kPremium', desc: '', args: []);
  }

  /// `Elite`
  String get kElite {
    return Intl.message('Elite', name: 'kElite', desc: '', args: []);
  }

  /// `Boost Now`
  String get kBoostNow {
    return Intl.message('Boost Now', name: 'kBoostNow', desc: '', args: []);
  }

  /// `Upgrade to Premium`
  String get kUpgradeToPremium {
    return Intl.message(
      'Upgrade to Premium',
      name: 'kUpgradeToPremium',
      desc: '',
      args: [],
    );
  }

  /// `Go Elite`
  String get kGoElite {
    return Intl.message('Go Elite', name: 'kGoElite', desc: '', args: []);
  }

  /// `Appears at the top of search results for 24 hours`
  String get kAppearsAtTheTop24 {
    return Intl.message(
      'Appears at the top of search results for 24 hours',
      name: 'kAppearsAtTheTop24',
      desc: '',
      args: [],
    );
  }

  /// `Featured badge on your auction`
  String get kFeaturedBadge {
    return Intl.message(
      'Featured badge on your auction',
      name: 'kFeaturedBadge',
      desc: '',
      args: [],
    );
  }

  /// `Highlighted card color to attract buyers`
  String get kHighlightedCard {
    return Intl.message(
      'Highlighted card color to attract buyers',
      name: 'kHighlightedCard',
      desc: '',
      args: [],
    );
  }

  /// `Appears at the top of search results for 3 days`
  String get kAppearsAtTheTop3D {
    return Intl.message(
      'Appears at the top of search results for 3 days',
      name: 'kAppearsAtTheTop3D',
      desc: '',
      args: [],
    );
  }

  /// `Push notifications sent to interested buyers`
  String get kPushNotifications {
    return Intl.message(
      'Push notifications sent to interested buyers',
      name: 'kPushNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Featured badge & highlighted card`
  String get kFeaturedBadgeHighl {
    return Intl.message(
      'Featured badge & highlighted card',
      name: 'kFeaturedBadgeHighl',
      desc: '',
      args: [],
    );
  }

  /// `Basic Analytics`
  String get kBasicAnalytics {
    return Intl.message(
      'Basic Analytics',
      name: 'kBasicAnalytics',
      desc: '',
      args: [],
    );
  }

  /// `Pinned as a Top Banner on the homepage for 7 days`
  String get kPinnedAsTopBanner {
    return Intl.message(
      'Pinned as a Top Banner on the homepage for 7 days',
      name: 'kPinnedAsTopBanner',
      desc: '',
      args: [],
    );
  }

  /// `Instant push notifications to all interested buyers`
  String get kInstantPushNotific {
    return Intl.message(
      'Instant push notifications to all interested buyers',
      name: 'kInstantPushNotific',
      desc: '',
      args: [],
    );
  }

  /// `Detailed Analytics`
  String get kDetailedAnalytics {
    return Intl.message(
      'Detailed Analytics',
      name: 'kDetailedAnalytics',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade successful!`
  String get kSubscriptionUpgradeSuccess {
    return Intl.message(
      'Upgrade successful!',
      name: 'kSubscriptionUpgradeSuccess',
      desc: 'Shown when a seller upgrades successfully',
      args: [],
    );
  }

  /// `Upgrade failed. Please try again.`
  String get kSubscriptionUpgradeFailed {
    return Intl.message(
      'Upgrade failed. Please try again.',
      name: 'kSubscriptionUpgradeFailed',
      desc: 'Shown when a seller upgrade request fails',
      args: [],
    );
  }

  /// `Active Plan`
  String get kActivePlan {
    return Intl.message(
      'Active Plan',
      name: 'kActivePlan',
      desc: 'Label for the seller current upgrade plan',
      args: [],
    );
  }

  /// `No active plan`
  String get kNoPlanActive {
    return Intl.message(
      'No active plan',
      name: 'kNoPlanActive',
      desc: 'Shown when the seller has no active upgrade plan',
      args: [],
    );
  }

  /// `Current Plan`
  String get kCurrentPlan {
    return Intl.message(
      'Current Plan',
      name: 'kCurrentPlan',
      desc: 'Button label for the seller active subscription tier',
      args: [],
    );
  }

  /// `Included in Current Plan`
  String get kIncludedInCurrentPlan {
    return Intl.message(
      'Included in Current Plan',
      name: 'kIncludedInCurrentPlan',
      desc: 'Button label for lower tiers already covered by a higher plan',
      args: [],
    );
  }

  /// `Change Password`
  String get kChangePassword {
    return Intl.message(
      'Change Password',
      name: 'kChangePassword',
      desc: 'Title and button label for change password screen',
      args: [],
    );
  }

  /// `Current Password`
  String get kCurrentPassword {
    return Intl.message(
      'Current Password',
      name: 'kCurrentPassword',
      desc: 'Current password field label',
      args: [],
    );
  }

  /// `New Password`
  String get kNewPassword {
    return Intl.message(
      'New Password',
      name: 'kNewPassword',
      desc: 'New password field label',
      args: [],
    );
  }

  /// `Confirm Password`
  String get kConfirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'kConfirmPassword',
      desc: 'Confirm password field label',
      args: [],
    );
  }

  /// `Password changed successfully.`
  String get kPasswordChanged {
    return Intl.message(
      'Password changed successfully.',
      name: 'kPasswordChanged',
      desc: 'Shown after successful password change',
      args: [],
    );
  }

  /// `Passwords do not match.`
  String get kPasswordMismatch {
    return Intl.message(
      'Passwords do not match.',
      name: 'kPasswordMismatch',
      desc: 'Validation when confirm password does not match',
      args: [],
    );
  }

  /// `Password must be at least 8 characters.`
  String get kPasswordTooShort {
    return Intl.message(
      'Password must be at least 8 characters.',
      name: 'kPasswordTooShort',
      desc: 'Validation for password minimum length',
      args: [],
    );
  }

  /// `New password must differ from current.`
  String get kPasswordSameAsCurrent {
    return Intl.message(
      'New password must differ from current.',
      name: 'kPasswordSameAsCurrent',
      desc: 'Validation when new password matches current password',
      args: [],
    );
  }

  /// `Search history`
  String get historySearchHint {
    return Intl.message(
      'Search history',
      name: 'historySearchHint',
      desc: 'Search field hint in history screen',
      args: [],
    );
  }

  /// `Retry`
  String get historyRetry {
    return Intl.message(
      'Retry',
      name: 'historyRetry',
      desc: 'Retry button text in history screen',
      args: [],
    );
  }

  /// `Export`
  String get historyExport {
    return Intl.message(
      'Export',
      name: 'historyExport',
      desc: 'Export button label in history screen',
      args: [],
    );
  }

  /// `Auctions`
  String get historyAuctions {
    return Intl.message(
      'Auctions',
      name: 'historyAuctions',
      desc: 'Auctions label in history header',
      args: [],
    );
  }

  /// `No history found.`
  String get historyNoItems {
    return Intl.message(
      'No history found.',
      name: 'historyNoItems',
      desc: 'Empty state text when there are no history items',
      args: [],
    );
  }

  /// `No matching history found.`
  String get historyNoMatchingItems {
    return Intl.message(
      'No matching history found.',
      name: 'historyNoMatchingItems',
      desc: 'Empty state text when search has no results in history',
      args: [],
    );
  }

  /// `Upcoming`
  String get historyStatusUpcoming {
    return Intl.message(
      'Upcoming',
      name: 'historyStatusUpcoming',
      desc: 'Upcoming auction status label in history',
      args: [],
    );
  }

  /// `Active`
  String get historyStatusActive {
    return Intl.message(
      'Active',
      name: 'historyStatusActive',
      desc: 'Active auction status label in history',
      args: [],
    );
  }

  /// `Ending Soon`
  String get historyStatusEndingSoon {
    return Intl.message(
      'Ending Soon',
      name: 'historyStatusEndingSoon',
      desc: 'Ending soon auction status label in history',
      args: [],
    );
  }

  /// `Finished`
  String get historyStatusFinished {
    return Intl.message(
      'Finished',
      name: 'historyStatusFinished',
      desc: 'Finished auction status label in history',
      args: [],
    );
  }

  /// `Canceled`
  String get historyStatusCanceled {
    return Intl.message(
      'Canceled',
      name: 'historyStatusCanceled',
      desc: 'Canceled auction status label in history',
      args: [],
    );
  }

  /// `Sold`
  String get historyStatusSold {
    return Intl.message(
      'Sold',
      name: 'historyStatusSold',
      desc: 'Sold auction status label in history',
      args: [],
    );
  }

  /// `Starting Price`
  String get historyStartingPrice {
    return Intl.message(
      'Starting Price',
      name: 'historyStartingPrice',
      desc: 'Starting price label in history card',
      args: [],
    );
  }

  /// `Current Price`
  String get historyCurrentPrice {
    return Intl.message(
      'Current Price',
      name: 'historyCurrentPrice',
      desc: 'Current price label in history card',
      args: [],
    );
  }

  /// `Final Price`
  String get historyFinalPrice {
    return Intl.message(
      'Final Price',
      name: 'historyFinalPrice',
      desc: 'Final price label in history card',
      args: [],
    );
  }

  /// `Lot`
  String get historyLotLabel {
    return Intl.message(
      'Lot',
      name: 'historyLotLabel',
      desc: 'Lot label prefix in history card',
      args: [],
    );
  }

  /// `Edit Auction`
  String get auctionEditTitle {
    return Intl.message(
      'Edit Auction',
      name: 'auctionEditTitle',
      desc: 'Edit auction screen title',
      args: [],
    );
  }

  /// `Price & Duration`
  String get auctionPriceDuration {
    return Intl.message(
      'Price & Duration',
      name: 'auctionPriceDuration',
      desc: 'Price and duration screen title',
      args: [],
    );
  }

  /// `Bid Increment`
  String get auctionBidIncrement {
    return Intl.message(
      'Bid Increment',
      name: 'auctionBidIncrement',
      desc: 'Bid increment section title',
      args: [],
    );
  }

  /// `Auction Date`
  String get auctionDate {
    return Intl.message(
      'Auction Date',
      name: 'auctionDate',
      desc: 'Auction date section title',
      args: [],
    );
  }

  /// `Start Date`
  String get auctionStartDate {
    return Intl.message(
      'Start Date',
      name: 'auctionStartDate',
      desc: 'Auction start date field hint',
      args: [],
    );
  }

  /// `End Date`
  String get auctionEndDate {
    return Intl.message(
      'End Date',
      name: 'auctionEndDate',
      desc: 'Auction end date field hint',
      args: [],
    );
  }

  /// `Auction Duration`
  String get auctionDuration {
    return Intl.message(
      'Auction Duration',
      name: 'auctionDuration',
      desc: 'Auction duration label',
      args: [],
    );
  }

  /// `Publish`
  String get auctionBoostPublish {
    return Intl.message(
      'Publish',
      name: 'auctionBoostPublish',
      desc: 'Publish auction button label',
      args: [],
    );
  }

  /// `Publishing...`
  String get auctionPublishing {
    return Intl.message(
      'Publishing...',
      name: 'auctionPublishing',
      desc: 'Publishing auction button label',
      args: [],
    );
  }

  /// `Specify`
  String get auctionSpecify {
    return Intl.message(
      'Specify',
      name: 'auctionSpecify',
      desc: 'Specify custom value option',
      args: [],
    );
  }

  /// `Auction draft is missing.`
  String get auctionDraftMissing {
    return Intl.message(
      'Auction draft is missing.',
      name: 'auctionDraftMissing',
      desc: 'Missing auction draft validation',
      args: [],
    );
  }

  /// `Please enter a valid starting price.`
  String get auctionValidStartingPriceError {
    return Intl.message(
      'Please enter a valid starting price.',
      name: 'auctionValidStartingPriceError',
      desc: 'Invalid starting price validation',
      args: [],
    );
  }

  /// `Please enter a valid bid increment.`
  String get auctionValidBidIncrementError {
    return Intl.message(
      'Please enter a valid bid increment.',
      name: 'auctionValidBidIncrementError',
      desc: 'Invalid bid increment validation',
      args: [],
    );
  }

  /// `Please select a start date.`
  String get auctionSelectStartDateError {
    return Intl.message(
      'Please select a start date.',
      name: 'auctionSelectStartDateError',
      desc: 'Missing start date validation',
      args: [],
    );
  }

  /// `Please select an end date.`
  String get auctionSelectEndDateError {
    return Intl.message(
      'Please select an end date.',
      name: 'auctionSelectEndDateError',
      desc: 'Missing end date validation',
      args: [],
    );
  }

  /// `End date must be after start date.`
  String get auctionEndDateAfterStart {
    return Intl.message(
      'End date must be after start date.',
      name: 'auctionEndDateAfterStart',
      desc: 'End date ordering validation',
      args: [],
    );
  }

  /// `Please enter a valid duration.`
  String get auctionValidDurationError {
    return Intl.message(
      'Please enter a valid duration.',
      name: 'auctionValidDurationError',
      desc: 'Invalid duration validation',
      args: [],
    );
  }

  /// `Starts in`
  String get auctionStartsIn {
    return Intl.message(
      'Starts in',
      name: 'auctionStartsIn',
      desc: 'Auction start info label',
      args: [],
    );
  }

  /// `Ends in`
  String get auctionEndsIn {
    return Intl.message(
      'Ends in',
      name: 'auctionEndsIn',
      desc: 'Auction end info label',
      args: [],
    );
  }

  /// `Time Left`
  String get auctionTimeLeft {
    return Intl.message(
      'Time Left',
      name: 'auctionTimeLeft',
      desc: 'Auction remaining time label',
      args: [],
    );
  }

  /// `Details & Docs`
  String get auctionDetailsDocs {
    return Intl.message(
      'Details & Docs',
      name: 'auctionDetailsDocs',
      desc: 'Auction item details and documents label',
      args: [],
    );
  }

  /// `Used`
  String get auctionUsed {
    return Intl.message(
      'Used',
      name: 'auctionUsed',
      desc: 'Used condition label',
      args: [],
    );
  }

  /// `Lot Details`
  String get auctionLotDetails {
    return Intl.message(
      'Lot Details',
      name: 'auctionLotDetails',
      desc: 'Lot details section title',
      args: [],
    );
  }

  /// `Title`
  String get auctionTitle {
    return Intl.message(
      'Title',
      name: 'auctionTitle',
      desc: 'Auction title field hint',
      args: [],
    );
  }

  /// `Category`
  String get auctionCategory {
    return Intl.message(
      'Category',
      name: 'auctionCategory',
      desc: 'Auction category field hint',
      args: [],
    );
  }

  /// `Item`
  String get auctionItem {
    return Intl.message(
      'Item',
      name: 'auctionItem',
      desc: 'Auction item label',
      args: [],
    );
  }

  /// `Count`
  String get auctionCount {
    return Intl.message(
      'Count',
      name: 'auctionCount',
      desc: 'Auction item count field hint',
      args: [],
    );
  }

  /// `Warranty INFO`
  String get auctionWarrantyInfo {
    return Intl.message(
      'Warranty INFO',
      name: 'auctionWarrantyInfo',
      desc: 'Auction warranty info field hint',
      args: [],
    );
  }

  /// `Condition`
  String get auctionCondition {
    return Intl.message(
      'Condition',
      name: 'auctionCondition',
      desc: 'Auction condition section title',
      args: [],
    );
  }

  /// `Add Item`
  String get auctionAddItem {
    return Intl.message(
      'Add Item',
      name: 'auctionAddItem',
      desc: 'Add item action label',
      args: [],
    );
  }

  /// `Lot Description`
  String get auctionLotDescription {
    return Intl.message(
      'Lot Description',
      name: 'auctionLotDescription',
      desc: 'Lot description section title',
      args: [],
    );
  }

  /// `Save edits`
  String get auctionSaveEdits {
    return Intl.message(
      'Save edits',
      name: 'auctionSaveEdits',
      desc: 'Save edits button label',
      args: [],
    );
  }

  /// `Tap to change image`
  String get auctionTapToChangeImage {
    return Intl.message(
      'Tap to change image',
      name: 'auctionTapToChangeImage',
      desc: 'Hint below the auction image picker',
      args: [],
    );
  }

  /// `Tap to add images`
  String get auctionTapToAddImages {
    return Intl.message(
      'Tap to add images',
      name: 'auctionTapToAddImages',
      desc: 'Hint below the auction item images picker',
      args: [],
    );
  }

  /// `Please fill all required fields for item {index}.`
  String auctionItemFieldsRequired(int index) {
    return Intl.message(
      'Please fill all required fields for item $index.',
      name: 'auctionItemFieldsRequired',
      desc: 'Validation when required item fields are empty',
      args: [index],
    );
  }

  /// `Please enter a valid count for item {index}.`
  String auctionItemInvalidCount(int index) {
    return Intl.message(
      'Please enter a valid count for item $index.',
      name: 'auctionItemInvalidCount',
      desc: 'Validation when item count is invalid',
      args: [index],
    );
  }

  /// `Changes saved successfully`
  String get auctionChangesSaved {
    return Intl.message(
      'Changes saved successfully',
      name: 'auctionChangesSaved',
      desc: 'Edit auction success message',
      args: [],
    );
  }

  /// `Delete`
  String get auctionDeleteButton {
    return Intl.message(
      'Delete',
      name: 'auctionDeleteButton',
      desc: 'Delete auction action label',
      args: [],
    );
  }

  /// `Are you sure you want to delete this auction? This action cannot be undone.`
  String get auctionDeleteConfirmMessage {
    return Intl.message(
      'Are you sure you want to delete this auction? This action cannot be undone.',
      name: 'auctionDeleteConfirmMessage',
      desc: 'Delete auction confirmation message',
      args: [],
    );
  }

  /// `Auction deleted successfully`
  String get auctionDeleteSuccess {
    return Intl.message(
      'Auction deleted successfully',
      name: 'auctionDeleteSuccess',
      desc: 'Delete auction success message',
      args: [],
    );
  }

  /// `Auction updated successfully`
  String get auctionEditSuccess {
    return Intl.message(
      'Auction updated successfully',
      name: 'auctionEditSuccess',
      desc: 'Edit auction success message from API',
      args: [],
    );
  }

  /// `Failed to load auction details`
  String get auctionLoadError {
    return Intl.message(
      'Failed to load auction details',
      name: 'auctionLoadError',
      desc: 'Auction details load failure fallback',
      args: [],
    );
  }

  /// `New`
  String get auctionNew {
    return Intl.message(
      'New',
      name: 'auctionNew',
      desc: 'New condition label',
      args: [],
    );
  }

  /// `Used-Like New`
  String get auctionUsedLikeNew {
    return Intl.message(
      'Used-Like New',
      name: 'auctionUsedLikeNew',
      desc: 'Used like new condition label',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: 'Generic retry action label',
      args: [],
    );
  }

  /// `Chat`
  String get chatTitle {
    return Intl.message(
      'Chat',
      name: 'chatTitle',
      desc: 'Chat list screen title',
      args: [],
    );
  }

  /// `Search conversations`
  String get chatSearchHint {
    return Intl.message(
      'Search conversations',
      name: 'chatSearchHint',
      desc: 'Chat list search field hint',
      args: [],
    );
  }

  /// `No conversations yet`
  String get chatNoConversations {
    return Intl.message(
      'No conversations yet',
      name: 'chatNoConversations',
      desc: 'Shown when the seller has no conversations',
      args: [],
    );
  }

  /// `Type a message...`
  String get chatTypeMessage {
    return Intl.message(
      'Type a message...',
      name: 'chatTypeMessage',
      desc: 'Chat thread composer hint',
      args: [],
    );
  }

  /// `Send`
  String get chatSend {
    return Intl.message(
      'Send',
      name: 'chatSend',
      desc: 'Chat send action label',
      args: [],
    );
  }

  /// `No messages yet`
  String get chatNoMessages {
    return Intl.message(
      'No messages yet',
      name: 'chatNoMessages',
      desc: 'Shown when a chat thread is empty',
      args: [],
    );
  }

  /// `Failed to send message`
  String get chatSendFailed {
    return Intl.message(
      'Failed to send message',
      name: 'chatSendFailed',
      desc: 'Shown when sending a chat message fails',
      args: [],
    );
  }

  /// `You`
  String get chatYou {
    return Intl.message(
      'You',
      name: 'chatYou',
      desc: 'Label for the current user in chat',
      args: [],
    );
  }

  /// `Saved Cards`
  String get savedCards {
    return Intl.message(
      'Saved Cards',
      name: 'savedCards',
      desc: 'Wallet saved cards section title',
      args: [],
    );
  }

  /// `Saved Card`
  String get savedCard {
    return Intl.message(
      'Saved Card',
      name: 'savedCard',
      desc: 'Wallet saved card field label',
      args: [],
    );
  }

  /// `See all`
  String get seeAll {
    return Intl.message(
      'See all',
      name: 'seeAll',
      desc: 'See all action label',
      args: [],
    );
  }

  /// `Add new card`
  String get addNewCard {
    return Intl.message(
      'Add new card',
      name: 'addNewCard',
      desc: 'Wallet add new card shortcut label',
      args: [],
    );
  }

  /// `Wallet balance`
  String get walletBalance {
    return Intl.message(
      'Wallet balance',
      name: 'walletBalance',
      desc: 'Wallet balance section label',
      args: [],
    );
  }

  /// `Card`
  String get card {
    return Intl.message(
      'Card',
      name: 'card',
      desc: 'Generic card label',
      args: [],
    );
  }

  /// `Enter an amount`
  String get enterAmount {
    return Intl.message(
      'Enter an amount',
      name: 'enterAmount',
      desc: 'Validation message when amount is empty',
      args: [],
    );
  }

  /// `Enter a valid amount`
  String get enterValidAmount {
    return Intl.message(
      'Enter a valid amount',
      name: 'enterValidAmount',
      desc: 'Validation message when amount is invalid',
      args: [],
    );
  }

  /// `Enter the verification code sent to your email to continue your withdrawal.`
  String get verifyWithdrawalDescription {
    return Intl.message(
      'Enter the verification code sent to your email to continue your withdrawal.',
      name: 'verifyWithdrawalDescription',
      desc: 'Withdrawal OTP screen description',
      args: [],
    );
  }

  /// `Confirm withdrawal`
  String get confirmWithdrawal {
    return Intl.message(
      'Confirm withdrawal',
      name: 'confirmWithdrawal',
      desc: 'Confirm withdrawal action label',
      args: [],
    );
  }

  /// `Enter your password to confirm this withdrawal request.`
  String get confirmWithdrawalDescription {
    return Intl.message(
      'Enter your password to confirm this withdrawal request.',
      name: 'confirmWithdrawalDescription',
      desc: 'Withdrawal password confirmation description',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: 'Current password field label',
      args: [],
    );
  }

  /// `Welcome!`
  String get homeWelcomeGreeting {
    return Intl.message(
      'Welcome!',
      name: 'homeWelcomeGreeting',
      desc: 'Greeting shown above store name on home screen header',
      args: [],
    );
  }

  /// `Notifications`
  String get notificationsTitle {
    return Intl.message(
      'Notifications',
      name: 'notificationsTitle',
      desc: 'Notifications screen title',
      args: [],
    );
  }

  /// `Mark all`
  String get notificationsMarkAll {
    return Intl.message(
      'Mark all',
      name: 'notificationsMarkAll',
      desc: 'Mark all notifications as read action',
      args: [],
    );
  }

  /// `Notification Options`
  String get notificationsOptionsTitle {
    return Intl.message(
      'Notification Options',
      name: 'notificationsOptionsTitle',
      desc: 'Bottom sheet title for notification actions',
      args: [],
    );
  }

  /// `Delete`
  String get notificationsDelete {
    return Intl.message(
      'Delete',
      name: 'notificationsDelete',
      desc: 'Delete notification action',
      args: [],
    );
  }

  /// `Cancel`
  String get notificationsCancel {
    return Intl.message(
      'Cancel',
      name: 'notificationsCancel',
      desc: 'Cancel notification action',
      args: [],
    );
  }

  /// `No notifications yet`
  String get notificationsEmpty {
    return Intl.message(
      'No notifications yet',
      name: 'notificationsEmpty',
      desc: 'Empty state text on notifications screen',
      args: [],
    );
  }

  /// `Just now`
  String get notificationsJustNow {
    return Intl.message(
      'Just now',
      name: 'notificationsJustNow',
      desc: 'Relative time label for notifications created moments ago',
      args: [],
    );
  }

  /// `{count} min ago`
  String notificationsMinutesAgo(int count) {
    return Intl.message(
      '$count min ago',
      name: 'notificationsMinutesAgo',
      desc: 'Relative time label for notifications created minutes ago',
      args: [count],
    );
  }

  /// `{count} hr ago`
  String notificationsHoursAgo(int count) {
    return Intl.message(
      '$count hr ago',
      name: 'notificationsHoursAgo',
      desc: 'Relative time label for notifications created hours ago',
      args: [count],
    );
  }

  /// `{count} day(s) ago`
  String notificationsDaysAgo(int count) {
    return Intl.message(
      '$count day(s) ago',
      name: 'notificationsDaysAgo',
      desc: 'Relative time label for notifications created days ago',
      args: [count],
    );
  }

  /// `Lot Auction`
  String get auctionLotAuctionTitle {
    return Intl.message(
      'Lot Auction',
      name: 'auctionLotAuctionTitle',
      desc: 'Lot auction creation screen title',
      args: [],
    );
  }

  /// `Item Auction`
  String get auctionItemAuctionTitle {
    return Intl.message(
      'Item Auction',
      name: 'auctionItemAuctionTitle',
      desc: 'Item auction creation screen title',
      args: [],
    );
  }

  /// `Head Image +`
  String get auctionHeadImage {
    return Intl.message(
      'Head Image +',
      name: 'auctionHeadImage',
      desc: 'Auction image picker label before selecting an image',
      args: [],
    );
  }

  /// `Selected: {name}`
  String auctionSelectedFile(Object name) {
    return Intl.message(
      'Selected: $name',
      name: 'auctionSelectedFile',
      desc: 'Auction file selected label',
      args: [name],
    );
  }

  /// `Loading categories...`
  String get auctionLoadingCategories {
    return Intl.message(
      'Loading categories...',
      name: 'auctionLoadingCategories',
      desc: 'Hint shown while auction categories are loading',
      args: [],
    );
  }

  /// `Select a category for each item below.`
  String get auctionSelectCategoryPerItem {
    return Intl.message(
      'Select a category for each item below.',
      name: 'auctionSelectCategoryPerItem',
      desc: 'Hint telling the seller to choose a category for each lot item',
      args: [],
    );
  }

  /// `Save & Continue`
  String get auctionSaveContinue {
    return Intl.message(
      'Save & Continue',
      name: 'auctionSaveContinue',
      desc: 'Auction save and continue button label',
      args: [],
    );
  }

  /// `Remove`
  String get auctionRemove {
    return Intl.message(
      'Remove',
      name: 'auctionRemove',
      desc: 'Remove item action in auction forms',
      args: [],
    );
  }

  /// `Add Images +`
  String get auctionAddImages {
    return Intl.message(
      'Add Images +',
      name: 'auctionAddImages',
      desc: 'Auction item image picker label before selecting images',
      args: [],
    );
  }

  /// `{count} image(s) selected`
  String auctionSelectedImagesCount(int count) {
    return Intl.message(
      '$count image(s) selected',
      name: 'auctionSelectedImagesCount',
      desc: 'Auction selected images count label',
      args: [count],
    );
  }

  /// `Attributes`
  String get auctionAttributes {
    return Intl.message(
      'Attributes',
      name: 'auctionAttributes',
      desc: 'Auction attributes section title',
      args: [],
    );
  }

  /// `No categories found`
  String get auctionNoCategoriesFound {
    return Intl.message(
      'No categories found',
      name: 'auctionNoCategoriesFound',
      desc: 'Auction category dropdown empty hint',
      args: [],
    );
  }

  /// `Select category`
  String get auctionSelectCategoryHint {
    return Intl.message(
      'Select category',
      name: 'auctionSelectCategoryHint',
      desc: 'Auction category dropdown hint',
      args: [],
    );
  }

  /// `Select value`
  String get auctionSelectValue {
    return Intl.message(
      'Select value',
      name: 'auctionSelectValue',
      desc: 'Auction attribute dropdown hint',
      args: [],
    );
  }

  /// `True`
  String get auctionTrue {
    return Intl.message(
      'True',
      name: 'auctionTrue',
      desc: 'Boolean true option in auction attribute dropdown',
      args: [],
    );
  }

  /// `False`
  String get auctionFalse {
    return Intl.message(
      'False',
      name: 'auctionFalse',
      desc: 'Boolean false option in auction attribute dropdown',
      args: [],
    );
  }

  /// `Select date`
  String get auctionSelectDate {
    return Intl.message(
      'Select date',
      name: 'auctionSelectDate',
      desc: 'Auction date selection label',
      args: [],
    );
  }

  /// `Select date & time`
  String get auctionSelectDateTime {
    return Intl.message(
      'Select date & time',
      name: 'auctionSelectDateTime',
      desc: 'Auction date and time selection label',
      args: [],
    );
  }

  /// `Please enter the lot title.`
  String get auctionEnterLotTitle {
    return Intl.message(
      'Please enter the lot title.',
      name: 'auctionEnterLotTitle',
      desc: 'Validation when lot title is empty',
      args: [],
    );
  }

  /// `Please enter the lot description.`
  String get auctionEnterLotDescription {
    return Intl.message(
      'Please enter the lot description.',
      name: 'auctionEnterLotDescription',
      desc: 'Validation when lot description is empty',
      args: [],
    );
  }

  /// `Please enter a title for item {index}.`
  String auctionEnterItemTitle(int index) {
    return Intl.message(
      'Please enter a title for item $index.',
      name: 'auctionEnterItemTitle',
      desc: 'Validation when a lot item title is empty',
      args: [index],
    );
  }

  /// `Please enter a count for item {index}.`
  String auctionEnterItemCount(int index) {
    return Intl.message(
      'Please enter a count for item $index.',
      name: 'auctionEnterItemCount',
      desc: 'Validation when a lot item count is empty',
      args: [index],
    );
  }

  /// `Please enter a valid count for item {index}.`
  String auctionEnterValidItemCount(int index) {
    return Intl.message(
      'Please enter a valid count for item $index.',
      name: 'auctionEnterValidItemCount',
      desc: 'Validation when a lot item count is invalid',
      args: [index],
    );
  }

  /// `Please enter a description for item {index}.`
  String auctionEnterItemDescription(int index) {
    return Intl.message(
      'Please enter a description for item $index.',
      name: 'auctionEnterItemDescription',
      desc: 'Validation when a lot item description is empty',
      args: [index],
    );
  }

  /// `Please enter warranty info for item {index}.`
  String auctionEnterItemWarrantyInfo(int index) {
    return Intl.message(
      'Please enter warranty info for item $index.',
      name: 'auctionEnterItemWarrantyInfo',
      desc: 'Validation when a lot item warranty info is empty',
      args: [index],
    );
  }

  /// `Please select a category for item {index}.`
  String auctionSelectItemCategory(int index) {
    return Intl.message(
      'Please select a category for item $index.',
      name: 'auctionSelectItemCategory',
      desc: 'Validation when a lot item category is missing',
      args: [index],
    );
  }

  /// `Could not load attributes for item {index}. Please retry or choose another category.`
  String auctionItemAttributesLoadError(int index) {
    return Intl.message(
      'Could not load attributes for item $index. Please retry or choose another category.',
      name: 'auctionItemAttributesLoadError',
      desc: 'Validation when lot item attributes could not be loaded',
      args: [index],
    );
  }

  /// `Please enter a valid number for {attribute} in item {index}.`
  String auctionInvalidNumberForItemAttribute(Object attribute, int index) {
    return Intl.message(
      'Please enter a valid number for $attribute in item $index.',
      name: 'auctionInvalidNumberForItemAttribute',
      desc: 'Validation when a numeric lot item attribute is invalid',
      args: [attribute, index],
    );
  }

  /// `Please provide {attribute} for item {index}.`
  String auctionProvideItemAttribute(Object attribute, int index) {
    return Intl.message(
      'Please provide $attribute for item $index.',
      name: 'auctionProvideItemAttribute',
      desc: 'Validation when a required lot item attribute is missing',
      args: [attribute, index],
    );
  }

  /// `Could not load category attributes for this item. Try another category or retry later.`
  String get auctionLoadCategoryAttributesForItemError {
    return Intl.message(
      'Could not load category attributes for this item. Try another category or retry later.',
      name: 'auctionLoadCategoryAttributesForItemError',
      desc: 'Error shown when item category attributes fail to load',
      args: [],
    );
  }

  /// `Please enter the item title.`
  String get auctionEnterItemTitleSingle {
    return Intl.message(
      'Please enter the item title.',
      name: 'auctionEnterItemTitleSingle',
      desc: 'Validation when single item auction title is empty',
      args: [],
    );
  }

  /// `Please select a category.`
  String get auctionSelectCategoryError {
    return Intl.message(
      'Please select a category.',
      name: 'auctionSelectCategoryError',
      desc: 'Validation when auction category is missing',
      args: [],
    );
  }

  /// `Please enter warranty info.`
  String get auctionEnterWarrantyInfoError {
    return Intl.message(
      'Please enter warranty info.',
      name: 'auctionEnterWarrantyInfoError',
      desc: 'Validation when warranty info is empty',
      args: [],
    );
  }

  /// `Please enter the description.`
  String get auctionEnterDescriptionError {
    return Intl.message(
      'Please enter the description.',
      name: 'auctionEnterDescriptionError',
      desc: 'Validation when description is empty',
      args: [],
    );
  }

  /// `Please enter a valid count.`
  String get auctionEnterValidCountError {
    return Intl.message(
      'Please enter a valid count.',
      name: 'auctionEnterValidCountError',
      desc: 'Validation when auction count is invalid',
      args: [],
    );
  }

  /// `Could not load category attributes. Try another category.`
  String get auctionLoadCategoryAttributesError {
    return Intl.message(
      'Could not load category attributes. Try another category.',
      name: 'auctionLoadCategoryAttributesError',
      desc: 'Validation when category attributes could not be loaded',
      args: [],
    );
  }

  /// `Please enter a valid number for {attribute}.`
  String auctionInvalidNumberForAttribute(Object attribute) {
    return Intl.message(
      'Please enter a valid number for $attribute.',
      name: 'auctionInvalidNumberForAttribute',
      desc: 'Validation when a numeric auction attribute is invalid',
      args: [attribute],
    );
  }

  /// `Please provide {attribute}.`
  String auctionProvideAttribute(Object attribute) {
    return Intl.message(
      'Please provide $attribute.',
      name: 'auctionProvideAttribute',
      desc: 'Validation when a required auction attribute is missing',
      args: [attribute],
    );
  }

  /// `Could not load category attributes for this item.`
  String get auctionLoadCategoryAttributesForThisItemError {
    return Intl.message(
      'Could not load category attributes for this item.',
      name: 'auctionLoadCategoryAttributesForThisItemError',
      desc:
          'Error shown when category attributes fail to load for the single item auction form',
      args: [],
    );
  }

  /// `We couldn't find your account email. Please refresh your profile and try again.`
  String get withdrawalEmailMissing {
    return Intl.message(
      'We couldn\'t find your account email. Please refresh your profile and try again.',
      name: 'withdrawalEmailMissing',
      desc:
          'Shown when email is missing before starting withdrawal verification',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
