import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/storage/cache_helper.dart';
import 'package:safqaseller/core/storage/cache_keys.dart';
import 'package:safqaseller/features/auth/view_model/auth/auth_view_model_state.dart';
import 'package:safqaseller/features/home/view_model/home_view_model.dart';

class AuthViewModel extends Cubit<AuthViewModelState> {
  final CacheHelper cacheHelper;

  AuthViewModel(this.cacheHelper) : super(AuthInitial());

  /// Restores token + role from SharedPreferences on app start.
  void loadFromCache() {
    final token = cacheHelper.getData(key: CacheKeys.token) as String?;
    final isLoggedIn = cacheHelper.getData(key: CacheKeys.isLoggedIn) as bool?;
    final role =
        (cacheHelper.getData(key: CacheKeys.role) as String?) ?? 'User';

    if (isLoggedIn == true && token != null && token.isNotEmpty) {
      emit(AuthAuthenticated(token: token, role: role));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// Returns the current role (defaults to "User").
  String get currentRole {
    final s = state;
    if (s is AuthAuthenticated) return s.role;
    return 'User';
  }

  /// Updates role in state + cache.
  Future<void> setRole(String role) async {
    await cacheHelper.saveData(key: CacheKeys.role, value: role);
    final s = state;
    if (s is AuthAuthenticated) {
      emit(AuthAuthenticated(token: s.token, role: role));
    }
  }

  /// Called after successful login to set the initial auth state.
  /// The login API does NOT return a role, so we default to "User".
  Future<void> onLoginSuccess() async {
    final token = cacheHelper.getData(key: CacheKeys.token) as String? ?? '';
    final role =
        (cacheHelper.getData(key: CacheKeys.role) as String?) ?? 'User';

    // If no role is stored yet, default to "User"
    if (cacheHelper.getData(key: CacheKeys.role) == null) {
      await cacheHelper.saveData(key: CacheKeys.role, value: 'User');
    }

    getIt<HomeViewModel>().loadHomeData(force: true);
    emit(AuthAuthenticated(token: token, role: role));
  }

  /// Clears all stored data on logout.
  Future<void> logout() async {
    await cacheHelper.removeData(key: CacheKeys.token);
    await cacheHelper.removeData(key: CacheKeys.tokenTime);
    await cacheHelper.removeData(key: CacheKeys.refreshToken);
    await cacheHelper.removeData(key: CacheKeys.userId);
    await cacheHelper.removeData(key: CacheKeys.role);
    await cacheHelper.removeData(key: CacheKeys.isProfileCompleted);
    await cacheHelper.removeData(key: CacheKeys.sellerId);
    await cacheHelper.removeData(key: CacheKeys.activePlan);
    await cacheHelper.removeData(key: CacheKeys.activePlanUserId);
    await cacheHelper.saveData(key: CacheKeys.isLoggedIn, value: false);
    getIt<HomeViewModel>().reset();
    emit(AuthUnauthenticated());
  }
}
