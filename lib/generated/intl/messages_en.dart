// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(index) => "Please enter a count for item ${index}.";

  static String m1(index) => "Please enter a description for item ${index}.";

  static String m2(index) => "Please enter a title for item ${index}.";

  static String m3(index) => "Please enter warranty info for item ${index}.";

  static String m4(index) => "Please enter a valid count for item ${index}.";

  static String m5(attribute) =>
      "Please enter a valid number for ${attribute}.";

  static String m6(attribute, index) =>
      "Please enter a valid number for ${attribute} in item ${index}.";

  static String m7(index) =>
      "Could not load attributes for item ${index}. Please retry or choose another category.";

  static String m8(index) =>
      "Please fill all required fields for item ${index}.";

  static String m9(index) => "Please enter a valid count for item ${index}.";

  static String m10(attribute) => "Please provide ${attribute}.";

  static String m11(attribute, index) =>
      "Please provide ${attribute} for item ${index}.";

  static String m12(index) => "Please select a category for item ${index}.";

  static String m13(name) => "Selected: ${name}";

  static String m14(count) => "${count} image(s) selected";

  static String m15(count) => "${count} day(s) ago";

  static String m16(count) => "${count} hr ago";

  static String m17(count) => "${count} min ago";

  static String m18(count) => "Delete $count selected notifications?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "addNewCard": MessageLookupByLibrary.simpleMessage("Add new card"),
    "auctionAddImages": MessageLookupByLibrary.simpleMessage("Add Images +"),
    "auctionAddItem": MessageLookupByLibrary.simpleMessage("Add Item"),
    "auctionAttributes": MessageLookupByLibrary.simpleMessage("Attributes"),
    "auctionBidIncrement": MessageLookupByLibrary.simpleMessage(
      "Bid Increment",
    ),
    "auctionBoostPublish": MessageLookupByLibrary.simpleMessage("Publish"),
    "auctionCategory": MessageLookupByLibrary.simpleMessage("Category"),
    "auctionChangesSaved": MessageLookupByLibrary.simpleMessage(
      "Changes saved successfully",
    ),
    "auctionCondition": MessageLookupByLibrary.simpleMessage("Condition"),
    "auctionCount": MessageLookupByLibrary.simpleMessage("Count"),
    "auctionDate": MessageLookupByLibrary.simpleMessage("Auction Date"),
    "auctionDeleteButton": MessageLookupByLibrary.simpleMessage("Delete"),
    "auctionDeleteConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this auction? This action cannot be undone.",
    ),
    "auctionDeleteSuccess": MessageLookupByLibrary.simpleMessage(
      "Auction deleted successfully",
    ),
    "auctionDetailsDocs": MessageLookupByLibrary.simpleMessage(
      "Details & Docs",
    ),
    "auctionDraftMissing": MessageLookupByLibrary.simpleMessage(
      "Auction draft is missing.",
    ),
    "auctionDuration": MessageLookupByLibrary.simpleMessage("Auction Duration"),
    "auctionEditSuccess": MessageLookupByLibrary.simpleMessage(
      "Auction updated successfully",
    ),
    "auctionEditTitle": MessageLookupByLibrary.simpleMessage("Edit Auction"),
    "auctionEndDate": MessageLookupByLibrary.simpleMessage("End Date"),
    "auctionEndDateAfterStart": MessageLookupByLibrary.simpleMessage(
      "End date must be after start date.",
    ),
    "auctionEndsIn": MessageLookupByLibrary.simpleMessage("Ends in"),
    "auctionEnterDescriptionError": MessageLookupByLibrary.simpleMessage(
      "Please enter the description.",
    ),
    "auctionEnterItemCount": m0,
    "auctionEnterItemDescription": m1,
    "auctionEnterItemTitle": m2,
    "auctionEnterItemTitleSingle": MessageLookupByLibrary.simpleMessage(
      "Please enter the item title.",
    ),
    "auctionEnterItemWarrantyInfo": m3,
    "auctionEnterLotDescription": MessageLookupByLibrary.simpleMessage(
      "Please enter the lot description.",
    ),
    "auctionEnterLotTitle": MessageLookupByLibrary.simpleMessage(
      "Please enter the lot title.",
    ),
    "auctionEnterValidCountError": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid count.",
    ),
    "auctionEnterValidItemCount": m4,
    "auctionEnterWarrantyInfoError": MessageLookupByLibrary.simpleMessage(
      "Please enter warranty info.",
    ),
    "auctionFalse": MessageLookupByLibrary.simpleMessage("False"),
    "auctionHeadImage": MessageLookupByLibrary.simpleMessage("Head Image +"),
    "auctionInvalidNumberForAttribute": m5,
    "auctionInvalidNumberForItemAttribute": m6,
    "auctionItem": MessageLookupByLibrary.simpleMessage("Item"),
    "auctionItemAttributesLoadError": m7,
    "auctionItemAuctionTitle": MessageLookupByLibrary.simpleMessage(
      "Item Auction",
    ),
    "auctionItemFieldsRequired": m8,
    "auctionItemInvalidCount": m9,
    "auctionLoadCategoryAttributesError": MessageLookupByLibrary.simpleMessage(
      "Could not load category attributes. Try another category.",
    ),
    "auctionLoadCategoryAttributesForItemError":
        MessageLookupByLibrary.simpleMessage(
          "Could not load category attributes for this item. Try another category or retry later.",
        ),
    "auctionLoadCategoryAttributesForThisItemError":
        MessageLookupByLibrary.simpleMessage(
          "Could not load category attributes for this item.",
        ),
    "auctionLoadError": MessageLookupByLibrary.simpleMessage(
      "Failed to load auction details",
    ),
    "auctionLoadingCategories": MessageLookupByLibrary.simpleMessage(
      "Loading categories...",
    ),
    "auctionLotAuctionTitle": MessageLookupByLibrary.simpleMessage(
      "Lot Auction",
    ),
    "auctionLotDescription": MessageLookupByLibrary.simpleMessage(
      "Lot Description",
    ),
    "auctionLotDetails": MessageLookupByLibrary.simpleMessage("Lot Details"),
    "auctionNew": MessageLookupByLibrary.simpleMessage("New"),
    "auctionNoCategoriesFound": MessageLookupByLibrary.simpleMessage(
      "No categories found",
    ),
    "auctionPriceDuration": MessageLookupByLibrary.simpleMessage(
      "Price & Duration",
    ),
    "auctionProvideAttribute": m10,
    "auctionProvideItemAttribute": m11,
    "auctionPublishing": MessageLookupByLibrary.simpleMessage("Publishing..."),
    "auctionRemove": MessageLookupByLibrary.simpleMessage("Remove"),
    "auctionSaveContinue": MessageLookupByLibrary.simpleMessage(
      "Save & Continue",
    ),
    "auctionSaveEdits": MessageLookupByLibrary.simpleMessage("Save edits"),
    "auctionSelectCategoryError": MessageLookupByLibrary.simpleMessage(
      "Please select a category.",
    ),
    "auctionSelectCategoryHint": MessageLookupByLibrary.simpleMessage(
      "Select category",
    ),
    "auctionSelectCategoryPerItem": MessageLookupByLibrary.simpleMessage(
      "Select a category for each item below.",
    ),
    "auctionSelectDate": MessageLookupByLibrary.simpleMessage("Select date"),
    "auctionSelectDateTime": MessageLookupByLibrary.simpleMessage(
      "Select date & time",
    ),
    "auctionSelectEndDateError": MessageLookupByLibrary.simpleMessage(
      "Please select an end date.",
    ),
    "auctionSelectItemCategory": m12,
    "auctionSelectStartDateError": MessageLookupByLibrary.simpleMessage(
      "Please select a start date.",
    ),
    "auctionSelectValue": MessageLookupByLibrary.simpleMessage("Select value"),
    "auctionSelectedFile": m13,
    "auctionSelectedImagesCount": m14,
    "auctionSpecify": MessageLookupByLibrary.simpleMessage("Specify"),
    "auctionStartDate": MessageLookupByLibrary.simpleMessage("Start Date"),
    "auctionStartsIn": MessageLookupByLibrary.simpleMessage("Starts in"),
    "auctionTapToAddImages": MessageLookupByLibrary.simpleMessage(
      "Tap to add images",
    ),
    "auctionTapToChangeImage": MessageLookupByLibrary.simpleMessage(
      "Tap to change image",
    ),
    "auctionTimeLeft": MessageLookupByLibrary.simpleMessage("Time Left"),
    "auctionTitle": MessageLookupByLibrary.simpleMessage("Title"),
    "auctionTrue": MessageLookupByLibrary.simpleMessage("True"),
    "auctionUsed": MessageLookupByLibrary.simpleMessage("Used"),
    "auctionUsedLikeNew": MessageLookupByLibrary.simpleMessage("Used-Like New"),
    "auctionValidBidIncrementError": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid bid increment.",
    ),
    "auctionValidDurationError": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid duration.",
    ),
    "auctionValidStartingPriceError": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid starting price.",
    ),
    "auctionWarrantyInfo": MessageLookupByLibrary.simpleMessage(
      "Warranty INFO",
    ),
    "birthdate": MessageLookupByLibrary.simpleMessage("Birthdate"),
    "card": MessageLookupByLibrary.simpleMessage("Card"),
    "chatNoConversations": MessageLookupByLibrary.simpleMessage(
      "No conversations yet",
    ),
    "chatNoMessages": MessageLookupByLibrary.simpleMessage("No messages yet"),
    "chatSearchHint": MessageLookupByLibrary.simpleMessage(
      "Search conversations",
    ),
    "chatSend": MessageLookupByLibrary.simpleMessage("Send"),
    "chatSendFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to send message",
    ),
    "chatTitle": MessageLookupByLibrary.simpleMessage("Chat"),
    "chatTypeMessage": MessageLookupByLibrary.simpleMessage(
      "Type a message...",
    ),
    "chatYou": MessageLookupByLibrary.simpleMessage("You"),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("Confirm Password"),
    "confirmWithdrawal": MessageLookupByLibrary.simpleMessage(
      "Confirm withdrawal",
    ),
    "confirmWithdrawalDescription": MessageLookupByLibrary.simpleMessage(
      "Enter your password to confirm this withdrawal request.",
    ),
    "createAccount": MessageLookupByLibrary.simpleMessage("Create Account"),
    "createPassword": MessageLookupByLibrary.simpleMessage("Create Password"),
    "createPasswordDescription": MessageLookupByLibrary.simpleMessage(
      "Create a new password for your account",
    ),
    "currentPassword": MessageLookupByLibrary.simpleMessage("Current Password"),
    "dontHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account?",
    ),
    "dontReceiveCode": MessageLookupByLibrary.simpleMessage(
      "Didn\'t receive a code?",
    ),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emailConfirmedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Email confirmed successfully",
    ),
    "enterAmount": MessageLookupByLibrary.simpleMessage("Enter an amount"),
    "enterValidAmount": MessageLookupByLibrary.simpleMessage(
      "Enter a valid amount",
    ),
    "female": MessageLookupByLibrary.simpleMessage("Female"),
    "fieldRequired": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "forgetPasswordDescription": MessageLookupByLibrary.simpleMessage(
      "Enter your email address and we\'ll send you a code to reset your password",
    ),
    "forgetPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Forgot Password",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot Password?"),
    "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
    "gender": MessageLookupByLibrary.simpleMessage("Gender"),
    "haveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "historyAuctions": MessageLookupByLibrary.simpleMessage("Auctions"),
    "historyCurrentPrice": MessageLookupByLibrary.simpleMessage(
      "Current Price",
    ),
    "historyExport": MessageLookupByLibrary.simpleMessage("Export"),
    "historyFinalPrice": MessageLookupByLibrary.simpleMessage("Final Price"),
    "historyLotLabel": MessageLookupByLibrary.simpleMessage("Lot"),
    "historyNoItems": MessageLookupByLibrary.simpleMessage("No history found."),
    "historyNoMatchingItems": MessageLookupByLibrary.simpleMessage(
      "No matching history found.",
    ),
    "historyRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "historySearchHint": MessageLookupByLibrary.simpleMessage("Search history"),
    "historyStartingPrice": MessageLookupByLibrary.simpleMessage(
      "Starting Price",
    ),
    "historyStatusActive": MessageLookupByLibrary.simpleMessage("Active"),
    "historyStatusCanceled": MessageLookupByLibrary.simpleMessage("Canceled"),
    "historyStatusEndingSoon": MessageLookupByLibrary.simpleMessage(
      "Ending Soon",
    ),
    "historyStatusFinished": MessageLookupByLibrary.simpleMessage("Finished"),
    "historyStatusSold": MessageLookupByLibrary.simpleMessage("Sold"),
    "historyStatusUpcoming": MessageLookupByLibrary.simpleMessage("Upcoming"),
    "homeWelcomeGreeting": MessageLookupByLibrary.simpleMessage("Welcome!"),
    "invalidOtp": MessageLookupByLibrary.simpleMessage("Invalid OTP"),
    "kAccountNameBenef": MessageLookupByLibrary.simpleMessage(
      "Account Name / Beneficiary Name",
    ),
    "kAccountType": MessageLookupByLibrary.simpleMessage("Account Type"),
    "kActivePlan": MessageLookupByLibrary.simpleMessage("Active Plan"),
    "kAddCard": MessageLookupByLibrary.simpleMessage("Add Card"),
    "kAppearsAtTheTop24": MessageLookupByLibrary.simpleMessage(
      "Appears at the top of search results for 24 hours",
    ),
    "kAppearsAtTheTop3D": MessageLookupByLibrary.simpleMessage(
      "Appears at the top of search results for 3 days",
    ),
    "kArabic": MessageLookupByLibrary.simpleMessage("Arabic"),
    "kBankName": MessageLookupByLibrary.simpleMessage("Bank Name"),
    "kBasic": MessageLookupByLibrary.simpleMessage("Basic"),
    "kBasicAnalytics": MessageLookupByLibrary.simpleMessage("Basic Analytics"),
    "kBoostNow": MessageLookupByLibrary.simpleMessage("Boost Now"),
    "kBusinessAccount": MessageLookupByLibrary.simpleMessage(
      "Business Account",
    ),
    "kBusinessAddress": MessageLookupByLibrary.simpleMessage(
      "Business Address",
    ),
    "kBusinessNumber": MessageLookupByLibrary.simpleMessage("Business Number"),
    "kCairoEgypt": MessageLookupByLibrary.simpleMessage("Cairo, Egypt"),
    "kChangeLanguage": MessageLookupByLibrary.simpleMessage("Change Language"),
    "kChangePassword": MessageLookupByLibrary.simpleMessage("Change Password"),
    "kCity": MessageLookupByLibrary.simpleMessage("City"),
    "kCompanyIban": MessageLookupByLibrary.simpleMessage("Company IBAN"),
    "kConfirmPassword": MessageLookupByLibrary.simpleMessage(
      "Confirm Password",
    ),
    "kCountry": MessageLookupByLibrary.simpleMessage("Country"),
    "kCurrentPassword": MessageLookupByLibrary.simpleMessage(
      "Current Password",
    ),
    "kCurrentPlan": MessageLookupByLibrary.simpleMessage("Current Plan"),
    "kDeposit": MessageLookupByLibrary.simpleMessage("Deposit"),
    "kDepositNmoney": MessageLookupByLibrary.simpleMessage("Deposit\\nmoney"),
    "kDepositSuccessful": MessageLookupByLibrary.simpleMessage(
      "Deposit successful!",
    ),
    "kDescription": MessageLookupByLibrary.simpleMessage("Description"),
    "kDetailedAnalytics": MessageLookupByLibrary.simpleMessage(
      "Detailed Analytics",
    ),
    "kEdit": MessageLookupByLibrary.simpleMessage("Edit"),
    "kEditAccount": MessageLookupByLibrary.simpleMessage("Edit account"),
    "kEditAccountPhotoHint": MessageLookupByLibrary.simpleMessage(
      "Change profile photo",
    ),
    "kElite": MessageLookupByLibrary.simpleMessage("Elite"),
    "kEnglish": MessageLookupByLibrary.simpleMessage("English"),
    "kEnterDepositAmount": MessageLookupByLibrary.simpleMessage(
      "Enter deposit amount",
    ),
    "kEnterWithdrawalAmo": MessageLookupByLibrary.simpleMessage(
      "Enter withdrawal amount",
    ),
    "kExpires": MessageLookupByLibrary.simpleMessage("EXPIRES"),
    "kFeaturedBadge": MessageLookupByLibrary.simpleMessage(
      "Featured badge on your auction",
    ),
    "kFeaturedBadgeHighl": MessageLookupByLibrary.simpleMessage(
      "Featured badge & highlighted card",
    ),
    "kFinancialDetails": MessageLookupByLibrary.simpleMessage(
      "Financial Details",
    ),
    "kGoElite": MessageLookupByLibrary.simpleMessage("Go Elite"),
    "kHighlightedCard": MessageLookupByLibrary.simpleMessage(
      "Highlighted card color to attract buyers",
    ),
    "kHistory": MessageLookupByLibrary.simpleMessage("History"),
    "kIdentityVerificatio": MessageLookupByLibrary.simpleMessage(
      "Identity Verification",
    ),
    "kIncludedInCurrentPlan": MessageLookupByLibrary.simpleMessage(
      "Included in Current Plan",
    ),
    "kInstaPayNumberOp": MessageLookupByLibrary.simpleMessage(
      "Insta Pay Number (Optional)",
    ),
    "kInstantPushNotific": MessageLookupByLibrary.simpleMessage(
      "Instant push notifications to all interested buyers",
    ),
    "kLegalBusinessName": MessageLookupByLibrary.simpleMessage(
      "Legal Business Name",
    ),
    "kLegalDocuments": MessageLookupByLibrary.simpleMessage("Legal Documents"),
    "kLegalDocumentsAre": MessageLookupByLibrary.simpleMessage(
      "Legal documents are missing. Please go back.",
    ),
    "kLocalAccountNumber": MessageLookupByLibrary.simpleMessage(
      "Local Account Number (Optional)",
    ),
    "kLoginSuccessful": MessageLookupByLibrary.simpleMessage(
      "Login Successful!",
    ),
    "kLogoOptional": MessageLookupByLibrary.simpleMessage("Logo (Optional)"),
    "kLogout": MessageLookupByLibrary.simpleMessage("Logout"),
    "kNewLotAuction": MessageLookupByLibrary.simpleMessage("New Lot Auction"),
    "kNewPassword": MessageLookupByLibrary.simpleMessage("New Password"),
    "kNewSingleAuction": MessageLookupByLibrary.simpleMessage(
      "New Single Auction",
    ),
    "kNoPlanActive": MessageLookupByLibrary.simpleMessage("No active plan"),
    "kNoPreviousPageTo": MessageLookupByLibrary.simpleMessage(
      "No previous page to navigate back to",
    ),
    "kNoSavedCards": MessageLookupByLibrary.simpleMessage("No saved cards"),
    "kNoTransactionsYet": MessageLookupByLibrary.simpleMessage(
      "No transactions yet",
    ),
    "kOpeningChat": MessageLookupByLibrary.simpleMessage("Opening chat..."),
    "kPasswordChanged": MessageLookupByLibrary.simpleMessage(
      "Password changed successfully.",
    ),
    "kPasswordMismatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match.",
    ),
    "kPasswordSameAsCurrent": MessageLookupByLibrary.simpleMessage(
      "New password must differ from current.",
    ),
    "kPasswordTooShort": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 8 characters.",
    ),
    "kPhoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "kPinnedAsTopBanner": MessageLookupByLibrary.simpleMessage(
      "Pinned as a Top Banner on the homepage for 7 days",
    ),
    "kPleaseFillAllFiel": MessageLookupByLibrary.simpleMessage(
      "Please fill all fields including City",
    ),
    "kPleaseSelectABank": MessageLookupByLibrary.simpleMessage(
      "Please select a bank",
    ),
    "kPleaseSelectACoun": MessageLookupByLibrary.simpleMessage(
      "Please select a country and a city",
    ),
    "kPleaseUploadAllFo": MessageLookupByLibrary.simpleMessage(
      "Please upload all four documents",
    ),
    "kPleaseUploadAllTh": MessageLookupByLibrary.simpleMessage(
      "Please upload all three documents",
    ),
    "kPremium": MessageLookupByLibrary.simpleMessage("Premium"),
    "kPrimary": MessageLookupByLibrary.simpleMessage("Primary"),
    "kProfileUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Profile updated successfully",
    ),
    "kPushNotifications": MessageLookupByLibrary.simpleMessage(
      "Push notifications sent to interested buyers",
    ),
    "kReviewsRatings": MessageLookupByLibrary.simpleMessage(
      "Reviews & Ratings",
    ),
    "kSave": MessageLookupByLibrary.simpleMessage("Save"),
    "kSelectCity": MessageLookupByLibrary.simpleMessage("Select City"),
    "kSelectCountry": MessageLookupByLibrary.simpleMessage("Select Country"),
    "kSellerInformation": MessageLookupByLibrary.simpleMessage(
      "Seller Information",
    ),
    "kStatistics": MessageLookupByLibrary.simpleMessage("Statistics"),
    "kStoreDescription": MessageLookupByLibrary.simpleMessage(
      "Store Description",
    ),
    "kStoreInformation": MessageLookupByLibrary.simpleMessage(
      "Store Information",
    ),
    "kStoreLogoOptional": MessageLookupByLibrary.simpleMessage(
      "Store Logo (Optional)",
    ),
    "kStoreName": MessageLookupByLibrary.simpleMessage("Store Name"),
    "kSubscriptionUpgradeFailed": MessageLookupByLibrary.simpleMessage(
      "Upgrade failed. Please try again.",
    ),
    "kSubscriptionUpgradeSuccess": MessageLookupByLibrary.simpleMessage(
      "Upgrade successful!",
    ),
    "kTakeASelfieWithI": MessageLookupByLibrary.simpleMessage(
      "Take a Selfie with ID",
    ),
    "kTransactionHistory": MessageLookupByLibrary.simpleMessage(
      "Transaction History",
    ),
    "kTransactions": MessageLookupByLibrary.simpleMessage("Transactions"),
    "kUpgrade": MessageLookupByLibrary.simpleMessage("Upgrade"),
    "kUpgradeToPremium": MessageLookupByLibrary.simpleMessage(
      "Upgrade to Premium",
    ),
    "kUploadCommercialRe": MessageLookupByLibrary.simpleMessage(
      "Upload Commercial Registration (CR)",
    ),
    "kUploadNationalId": MessageLookupByLibrary.simpleMessage(
      "Upload National ID (Front)",
    ),
    "kUploadOwner": MessageLookupByLibrary.simpleMessage(
      "Upload owner\'s national ID (front)",
    ),
    "kUploadOwners": MessageLookupByLibrary.simpleMessage(
      "Upload Owner\'s National ID",
    ),
    "kUploadTaxId": MessageLookupByLibrary.simpleMessage("Upload Tax ID"),
    "kWallet": MessageLookupByLibrary.simpleMessage("Wallet"),
    "kWithdrawal": MessageLookupByLibrary.simpleMessage("Withdrawal"),
    "kWithdrawalNmoney": MessageLookupByLibrary.simpleMessage(
      "Withdrawal\\nmoney",
    ),
    "kWithdrawalSuccessfu": MessageLookupByLibrary.simpleMessage(
      "Withdrawal successful!",
    ),
    "logIn": MessageLookupByLibrary.simpleMessage("Log In"),
    "male": MessageLookupByLibrary.simpleMessage("Male"),
    "newPassword": MessageLookupByLibrary.simpleMessage("New Password"),
    "notificationsCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "notificationsDaysAgo": m15,
    "notificationsDelete": MessageLookupByLibrary.simpleMessage("Delete"),
    "notificationsEmpty": MessageLookupByLibrary.simpleMessage(
      "No notifications yet",
    ),
    "notificationsHoursAgo": m16,
    "notificationsJustNow": MessageLookupByLibrary.simpleMessage("Just now"),
    "notificationsMarkAll": MessageLookupByLibrary.simpleMessage("Mark all"),
    "notificationsAll": MessageLookupByLibrary.simpleMessage("All"),
    "notificationsSelect": MessageLookupByLibrary.simpleMessage("Select"),
    "notificationsDeleteSelectionConfirm": m18,
    "notificationsMinutesAgo": m17,
    "notificationsOptionsTitle": MessageLookupByLibrary.simpleMessage(
      "Notification Options",
    ),
    "notificationsTitle": MessageLookupByLibrary.simpleMessage("Notifications"),
    "onBoardingSubtitle1": MessageLookupByLibrary.simpleMessage(
      "Safqa transforms the long auction process into a fast, guaranteed digital experience, manage your auctions wherever you are.",
    ),
    "onBoardingSubtitle2": MessageLookupByLibrary.simpleMessage(
      "Participate in real-time bidding, or let the Proxy Bidding (Auto-Bid) system win automatically within your defined limit.",
    ),
    "onBoardingSubtitle3": MessageLookupByLibrary.simpleMessage(
      "A modern, bilingual (Arabic/English) design that allows you to navigate and bid seamlessly from any device.",
    ),
    "onBoardingTitle1": MessageLookupByLibrary.simpleMessage(
      "Stop wasting time!",
    ),
    "onBoardingTitle2": MessageLookupByLibrary.simpleMessage("Smart Bidding"),
    "onBoardingTitle3": MessageLookupByLibrary.simpleMessage(
      "Experience Designed For You",
    ),
    "or": MessageLookupByLibrary.simpleMessage("Or"),
    "otpExpired": MessageLookupByLibrary.simpleMessage("OTP has expired"),
    "otpResentSuccessfully": MessageLookupByLibrary.simpleMessage(
      "OTP resent successfully",
    ),
    "otpSentToEmail": MessageLookupByLibrary.simpleMessage(
      "OTP sent to your email",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordResetSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Password reset successfully",
    ),
    "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "profileLanguageConfirmButton": MessageLookupByLibrary.simpleMessage(
      "Confirm",
    ),
    "profileLanguageDialogMessage": MessageLookupByLibrary.simpleMessage(
      "Choose the language you want to use.",
    ),
    "profileLogoutDialogMessage": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to log out?",
    ),
    "profileSelectLanguageTitle": MessageLookupByLibrary.simpleMessage(
      "Select Language",
    ),
    "resend": MessageLookupByLibrary.simpleMessage("Resend"),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "savedCard": MessageLookupByLibrary.simpleMessage("Saved Card"),
    "savedCards": MessageLookupByLibrary.simpleMessage("Saved Cards"),
    "seeAll": MessageLookupByLibrary.simpleMessage("See all"),
    "sendCode": MessageLookupByLibrary.simpleMessage("Send Code"),
    "signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
    "signInWithApple": MessageLookupByLibrary.simpleMessage(
      "Sign in with Apple",
    ),
    "signInWithFacebook": MessageLookupByLibrary.simpleMessage(
      "Sign in with Facebook",
    ),
    "signInWithGoogle": MessageLookupByLibrary.simpleMessage(
      "Sign in with Google",
    ),
    "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "termsAccountUsageTitle": MessageLookupByLibrary.simpleMessage(
      "Account Usage",
    ),
    "termsAccurateInfo": MessageLookupByLibrary.simpleMessage(
      "Users are required to provide accurate and truthful information when using the platform.",
    ),
    "termsAndConditions": MessageLookupByLibrary.simpleMessage(
      "Terms and Conditions",
    ),
    "termsAndConditionsPrefix": MessageLookupByLibrary.simpleMessage(
      "By signing up, you agree to our",
    ),
    "termsAuctionMgmtTitle": MessageLookupByLibrary.simpleMessage(
      "Auction Management",
    ),
    "termsAuctionRules": MessageLookupByLibrary.simpleMessage(
      "Sellers must adhere to all platform auction rules, including minimum pricing guidelines.",
    ),
    "termsBiddingRulesTitle": MessageLookupByLibrary.simpleMessage(
      "Bidding Rules",
    ),
    "termsBindingBids": MessageLookupByLibrary.simpleMessage(
      "All bids placed on the platform are legally binding and cannot be retracted.",
    ),
    "termsBuyerAge": MessageLookupByLibrary.simpleMessage(
      "Buyers must be at least 18 years of age to create an account and participate in auctions.",
    ),
    "termsBuyerAppTitle": MessageLookupByLibrary.simpleMessage(
      "Buyer Application",
    ),
    "termsBuyerCredentials": MessageLookupByLibrary.simpleMessage(
      "Buyers are responsible for maintaining the confidentiality of their account credentials.",
    ),
    "termsBuyerMultipleAccounts": MessageLookupByLibrary.simpleMessage(
      "Creating multiple accounts for the same individual is strictly prohibited.",
    ),
    "termsChangesTitle": MessageLookupByLibrary.simpleMessage(
      "Changes to Terms",
    ),
    "termsContinuedUse": MessageLookupByLibrary.simpleMessage(
      "Continued use of the platform after any changes constitutes acceptance of the updated terms.",
    ),
    "termsDataCollected": MessageLookupByLibrary.simpleMessage(
      "Safqa collects personal data including name, email, phone number, and transaction history.",
    ),
    "termsDataProtected": MessageLookupByLibrary.simpleMessage(
      "All collected data is stored securely and protected against unauthorized access.",
    ),
    "termsDeliveryInfo": MessageLookupByLibrary.simpleMessage(
      "Accurate delivery information must be provided to ensure smooth and timely shipments.",
    ),
    "termsDeliveryTitle": MessageLookupByLibrary.simpleMessage("Delivery"),
    "termsDisputeDecisions": MessageLookupByLibrary.simpleMessage(
      "Safqa\'s dispute resolution team will review all submitted evidence and make a final decision.",
    ),
    "termsDisputesTitle": MessageLookupByLibrary.simpleMessage("Disputes"),
    "termsDowntime": MessageLookupByLibrary.simpleMessage(
      "The platform may experience scheduled or unscheduled downtime for maintenance purposes.",
    ),
    "termsFailureToDeliver": MessageLookupByLibrary.simpleMessage(
      "Failure to deliver items may result in account suspension and financial penalties.",
    ),
    "termsFeesTitle": MessageLookupByLibrary.simpleMessage("Fees"),
    "termsHighestBidWins": MessageLookupByLibrary.simpleMessage(
      "The highest bid at the close of the auction wins the item.",
    ),
    "termsHonestDescriptions": MessageLookupByLibrary.simpleMessage(
      "Sellers must provide honest and accurate descriptions of all items listed for auction.",
    ),
    "termsIntermediary": MessageLookupByLibrary.simpleMessage(
      "Safqa acts solely as an intermediary between buyers and sellers and does not guarantee transaction outcomes.",
    ),
    "termsLiabilityTitle": MessageLookupByLibrary.simpleMessage("Liability"),
    "termsManipulateBids": MessageLookupByLibrary.simpleMessage(
      "Any attempt to manipulate bids or collude with other bidders is strictly prohibited.",
    ),
    "termsMonitored": MessageLookupByLibrary.simpleMessage(
      "All activities on the platform are monitored to ensure compliance and security.",
    ),
    "termsNoModifyActive": MessageLookupByLibrary.simpleMessage(
      "Active auction listings cannot be modified once bidding has commenced.",
    ),
    "termsNoShareData": MessageLookupByLibrary.simpleMessage(
      "Safqa does not share personal user data with third parties without explicit user consent.",
    ),
    "termsNotResponsible": MessageLookupByLibrary.simpleMessage(
      "Safqa is not responsible for losses arising from user errors or third-party service failures.",
    ),
    "termsNotifGenerated": MessageLookupByLibrary.simpleMessage(
      "Notifications are automatically generated for key events such as new bids, auction endings, and payments.",
    ),
    "termsNotifInformational": MessageLookupByLibrary.simpleMessage(
      "Notifications are for informational purposes only and do not constitute legal or financial advice.",
    ),
    "termsNotifPolicyTitle": MessageLookupByLibrary.simpleMessage(
      "Notification Policy",
    ),
    "termsPaymentsTitle": MessageLookupByLibrary.simpleMessage("Payments"),
    "termsPlatformCompliance": MessageLookupByLibrary.simpleMessage(
      "All users must comply with the platform\'s rules and regulations at all times.",
    ),
    "termsPlatformFees": MessageLookupByLibrary.simpleMessage(
      "Safqa charges a platform fee on all successfully completed auction transactions.",
    ),
    "termsPrivacyDataTitle": MessageLookupByLibrary.simpleMessage(
      "Privacy & Data",
    ),
    "termsProxyBiddingRules": MessageLookupByLibrary.simpleMessage(
      "Proxy bidding allows the system to automatically bid on your behalf up to your maximum limit.",
    ),
    "termsRaiseDisputes": MessageLookupByLibrary.simpleMessage(
      "Buyers may raise a dispute within 48 hours of receiving an item that does not match the description.",
    ),
    "termsRefundsPolicy": MessageLookupByLibrary.simpleMessage(
      "Refunds are processed within 7 business days after a valid dispute is resolved in the buyer\'s favor.",
    ),
    "termsReviewNotif": MessageLookupByLibrary.simpleMessage(
      "Users are responsible for reviewing all notifications and taking appropriate action in a timely manner.",
    ),
    "termsSecurityDeposits": MessageLookupByLibrary.simpleMessage(
      "Security deposits may be required for certain high-value auctions.",
    ),
    "termsSellerAccuracy": MessageLookupByLibrary.simpleMessage(
      "Sellers are responsible for the accuracy and completeness of their product listings.",
    ),
    "termsSellerAppTitle": MessageLookupByLibrary.simpleMessage(
      "Seller Application",
    ),
    "termsSellerApproval": MessageLookupByLibrary.simpleMessage(
      "Seller accounts are subject to approval by the Safqa team before becoming active.",
    ),
    "termsSellerRegTitle": MessageLookupByLibrary.simpleMessage(
      "Seller Registration",
    ),
    "termsSellerVerification": MessageLookupByLibrary.simpleMessage(
      "All sellers must complete identity verification before listing items for auction.",
    ),
    "termsSuspendAccounts": MessageLookupByLibrary.simpleMessage(
      "Safqa reserves the right to suspend or terminate accounts that violate these terms.",
    ),
    "termsTimelyDelivery": MessageLookupByLibrary.simpleMessage(
      "Sellers are obligated to deliver items to winning buyers within the agreed timeframe.",
    ),
    "termsTrackEarnings": MessageLookupByLibrary.simpleMessage(
      "Sellers can track their earnings and fee deductions in real time through the seller dashboard.",
    ),
    "termsUpdatedAnytime": MessageLookupByLibrary.simpleMessage(
      "Safqa reserves the right to update these terms and conditions at any time without prior notice.",
    ),
    "termsWalletBalance": MessageLookupByLibrary.simpleMessage(
      "Buyers must maintain sufficient wallet balance to cover their bids and purchases.",
    ),
    "verificationCode": MessageLookupByLibrary.simpleMessage(
      "Verification Code",
    ),
    "verificationCodeDescription": MessageLookupByLibrary.simpleMessage(
      "Enter the verification code sent to your email",
    ),
    "verify": MessageLookupByLibrary.simpleMessage("Verify"),
    "verifyWithdrawalDescription": MessageLookupByLibrary.simpleMessage(
      "Enter the verification code sent to your email to continue your withdrawal.",
    ),
    "walletBalance": MessageLookupByLibrary.simpleMessage("Wallet balance"),
    "withdrawalEmailMissing": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t find your account email. Please refresh your profile and try again.",
    ),
  };
}
