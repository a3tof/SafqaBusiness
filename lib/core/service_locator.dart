import 'dart:math';
import 'package:get_it/get_it.dart';
import 'package:safqaseller/core/network/dio_client.dart';
import 'package:safqaseller/core/storage/cache_helper.dart';
import 'package:safqaseller/core/storage/cache_keys.dart';
import 'package:safqaseller/features/auth/model/repositories/auth_repository.dart';
import 'package:safqaseller/features/auth/view_model/auth/auth_view_model.dart';
import 'package:safqaseller/features/auth/view_model/confirm_email/confirm_email_view_model.dart';
import 'package:safqaseller/features/auth/view_model/login/login_view_model.dart';
import 'package:safqaseller/features/auth/view_model/logout/logout_view_model.dart';
import 'package:safqaseller/features/auth/view_model/register/register_view_model.dart';
import 'package:safqaseller/features/forgot_password/model/repositories/forgot_password_repository.dart';
import 'package:safqaseller/features/forgot_password/view_model/forgot_password_view_model.dart';
import 'package:safqaseller/features/history/model/repositories/history_repository.dart';
import 'package:safqaseller/features/history/view_model/history_view_model.dart';
import 'package:safqaseller/features/profile/model/repositories/profile_repository.dart';
import 'package:safqaseller/features/profile/view_model/edit_account/edit_account_view_model.dart';
import 'package:safqaseller/features/profile/view_model/profile_view_model.dart';
import 'package:safqaseller/features/seller/model/repositories/seller_repository.dart';
import 'package:safqaseller/features/seller/view_model/seller_view_model.dart';
import 'package:safqaseller/features/home/view_model/home_view_model.dart';
import 'package:safqaseller/features/notifications/model/repositories/notifications_repository.dart';
import 'package:safqaseller/features/notifications/view_model/notifications/notifications_view_model.dart';
import 'package:safqaseller/features/wallet/model/repositories/wallet_repository.dart';
import 'package:safqaseller/features/wallet/view_model/add_card/add_card_view_model.dart';
import 'package:safqaseller/features/wallet/view_model/deposit/deposit_view_model.dart';
import 'package:safqaseller/features/wallet/view_model/wallet/wallet_view_model.dart';
import 'package:safqaseller/features/wallet/view_model/withdrawal/withdrawal_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 1. External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // 2. Core
  getIt.registerLazySingleton(() => CacheHelper(sharedPreferences: getIt()));

  final cacheHelper = getIt<CacheHelper>();
  if (cacheHelper.getData(key: CacheKeys.deviceId) == null) {
    final deviceId = _generateDeviceId();
    await cacheHelper.saveData(key: CacheKeys.deviceId, value: deviceId);
  }

  getIt.registerLazySingleton(() => DioHelper(cacheHelper: getIt()));

  // 3. Repositories
  getIt.registerLazySingleton(
    () => AuthRepository(dioHelper: getIt(), cacheHelper: getIt()),
  );
  getIt.registerLazySingleton(
    () => ForgotPasswordRepository(dioHelper: getIt()),
  );
  getIt.registerLazySingleton(() => WalletRepository(dioHelper: getIt()));
  getIt.registerLazySingleton(() => SellerRepository(dioHelper: getIt()));
  getIt.registerLazySingleton(
    () => NotificationsRepository(dioHelper: getIt()),
  );
  getIt.registerLazySingleton(() => ProfileRepository(dioHelper: getIt()));
  getIt.registerLazySingleton(() => HistoryRepository(dioHelper: getIt()));

  // 4. Global ViewModels (singletons — live for the app lifetime)
  getIt.registerLazySingleton(() => AuthViewModel(getIt()));
  getIt.registerLazySingleton(
    () => ProfileViewModel(cacheHelper: getIt(), profileRepository: getIt()),
  );

  // 5. ViewModels (factory = new instance per call)
  getIt.registerFactory(() => RegisterViewModel(getIt()));
  getIt.registerFactory(() => LoginViewModel(getIt()));
  getIt.registerFactory(() => ConfirmEmailViewModel(getIt()));
  getIt.registerFactory(() => ForgotPasswordViewModel(getIt()));
  getIt.registerFactory(() => LogoutViewModel(getIt<AuthViewModel>()));
  getIt.registerFactory(() => WalletViewModel(getIt()));
  getIt.registerFactory(() => AddCardViewModel(getIt()));
  getIt.registerFactory(() => DepositViewModel(getIt()));
  getIt.registerFactory(() => WithdrawalViewModel(getIt()));
  getIt.registerFactory(
    () => SellerViewModel(sellerRepository: getIt(), cacheHelper: getIt()),
  );
  getIt.registerFactory(() => NotificationsViewModel(getIt()));
  getIt.registerFactory(() => HomeViewModel(getIt()));
  getIt.registerFactory(() => HistoryViewModel(getIt()));
  getIt.registerFactory(() => EditAccountViewModel(getIt()));
}

String _generateDeviceId() {
  final random = Random.secure();
  return List.generate(
    32,
    (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
}
