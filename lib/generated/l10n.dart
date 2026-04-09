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

  /// `Upload Owner\`
  String get kUploadOwner {
    return Intl.message(
      'Upload Owner\\',
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
