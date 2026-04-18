import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/core/storage/cache_helper.dart';
import 'package:safqaseller/core/storage/cache_keys.dart';

/// App-wide theme mode (system / light / dark).
///
/// Registered as a singleton in the service locator and provided
/// near the root of the widget tree via `MultiBlocProvider`.
class ThemeViewModel extends Cubit<ThemeMode> {
  ThemeViewModel(this._cache) : super(ThemeMode.system) {
    _loadFromCache();
  }

  final CacheHelper _cache;

  void _loadFromCache() {
    final saved = _cache.getData(key: CacheKeys.themeMode) as String?;
    switch (saved) {
      case 'light':
        emit(ThemeMode.light);
      case 'dark':
        emit(ThemeMode.dark);
      default:
        emit(ThemeMode.system);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final label = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await _cache.saveData(key: CacheKeys.themeMode, value: label);
    emit(mode);
  }

  /// Convenience toggle: light → dark → system → light …
  Future<void> cycleThemeMode() async {
    final next = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
      _ => ThemeMode.light,
    };
    await setThemeMode(next);
  }

  bool get isDark => state == ThemeMode.dark;
  bool get isLight => state == ThemeMode.light;
  bool get isSystem => state == ThemeMode.system;
}
