import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:safqaseller/core/config/app_config.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/storage/cache_helper.dart';
import 'package:safqaseller/core/storage/cache_keys.dart';
import 'package:safqaseller/features/auth/view/signin_view.dart';
import 'package:safqaseller/features/auth/view_model/auth/auth_view_model.dart';
import 'package:safqaseller/features/profile/view_model/profile_view_model.dart';

class DioHelper {
  final Dio dio;
  final CacheHelper _cacheHelper;
  bool _isExpiringSession = false;

  DioHelper({required CacheHelper cacheHelper})
    : _cacheHelper = cacheHelper,
      dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          receiveDataWhenStatusError: true,
          // Accept every status code — repositories decide what is success/failure.
          validateStatus: (_) => true,
          headers: {'x-api-key': AppConfig.apiKey},
        ),
      ) {
    // ── Header injection + token refresh ────────────────────────────────────
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final deviceId = _cacheHelper.getData(key: CacheKeys.deviceId);
          if (deviceId != null) {
            options.headers['DeviceId'] = deviceId;
          }
          // Skip refresh logic on the refresh call itself to prevent loops.
          if (options.extra['requiresAuth'] == true &&
              options.extra['_refreshing'] != true) {
            final token = await _getValidToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
        onResponse: (response, handler) async {
          final options = response.requestOptions;
          final shouldHandleUnauthorized =
              options.extra['requiresAuth'] == true &&
              options.extra['_refreshing'] != true &&
              options.extra['_skipSessionExpiry'] != true &&
              response.statusCode == 401;

          if (shouldHandleUnauthorized) {
            await _expireSession();
          }

          handler.next(response);
        },
      ),
    );

    // ── Request / response logger (debug builds only) ───────────────────────
    if (kDebugMode) {
      dio.interceptors.add(_ApiLogger());
    }
  }

  // ── Token expiry + refresh ───────────────────────────────────────────────

  /// Returns a valid token, refreshing it first if it is older than 5 hours.
  Future<String?> _getValidToken() async {
    final token = _cacheHelper.getData(key: CacheKeys.token) as String?;
    if (token == null || token.isEmpty) return null;

    final tokenTimeStr =
        _cacheHelper.getData(key: CacheKeys.tokenTime) as String?;
    if (tokenTimeStr != null) {
      final tokenTime = DateTime.tryParse(tokenTimeStr);
      if (tokenTime != null &&
          DateTime.now().difference(tokenTime).inHours >= 5) {
        final refreshByRefreshToken = await _refreshWithRefreshToken();
        if (refreshByRefreshToken.token != null) {
          return refreshByRefreshToken.token;
        }

        final refreshByAccessToken = await _refreshWithAccessToken(token);
        if (refreshByAccessToken.token != null) {
          return refreshByAccessToken.token;
        }

        if (refreshByRefreshToken.rejected || refreshByAccessToken.rejected) {
          await _expireSession(redirectToLogin: false);
          return null;
        }

        return token;
      }
    }
    return token;
  }

  /// Calls Auth/refresh-token with the expired access token as a JSON string.
  Future<_RefreshAttempt> _refreshWithAccessToken(String expiredToken) async {
    try {
      final response = await dio.post<dynamic>(
        'Auth/refresh-token',
        data: jsonEncode(expiredToken),
        options: Options(
          extra: {'_refreshing': true},
          contentType: 'application/json',
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return _RefreshAttempt(
          token: await _storeRefreshedSession(response.data),
        );
      }

      return _RefreshAttempt(rejected: _isRejectedRefreshStatus(response.statusCode));
    } catch (e) {
      if (kDebugMode) debugPrint('Token refresh failed: $e');
    }
    return const _RefreshAttempt();
  }

  /// Explicit refresh path using the stored refresh token object payload.
  /// Useful when the backend needs a newly issued token with updated seller claims.
  Future<String?> forceRefreshSession() async {
    final refreshToken =
        _cacheHelper.getData(key: CacheKeys.refreshToken) as String?;
    if (refreshToken == null || refreshToken.isEmpty) return null;

    final result = await _refreshWithRefreshToken();
    return result.token;
  }

  /// Explicit refresh path using the currently cached access token as JSON string.
  /// Useful after flows like password change when the backend should issue a fresh token.
  Future<String?> refreshSessionWithStoredToken() async {
    final token = _cacheHelper.getData(key: CacheKeys.token) as String?;
    if (token == null || token.isEmpty) {
      return null;
    }

    final result = await _refreshWithAccessToken(token);
    return result.token;
  }

  /// Stores auth/session tokens from a successful backend response.
  Future<String?> storeSessionFromResponse(dynamic data) async {
    return _storeRefreshedSession(data);
  }

  Future<String?> _storeRefreshedSession(dynamic data) async {
    final body = _decodeIfString(data);
    if (body is! Map) return null;

    final newToken = (body['Token'] ?? body['token']) as String?;
    if (newToken == null || newToken.isEmpty) return null;

    await _cacheHelper.saveData(key: CacheKeys.token, value: newToken);
    await _cacheHelper.saveData(
      key: CacheKeys.tokenTime,
      value: DateTime.now().toIso8601String(),
    );

    final newRefresh =
        (body['RefreshToken'] ?? body['refreshToken']) as String?;
    if (newRefresh != null && newRefresh.isNotEmpty) {
      await _cacheHelper.saveData(
        key: CacheKeys.refreshToken,
        value: newRefresh,
      );
    }

    return newToken;
  }

  Future<bool> ensureSessionIsValid({bool redirectToLogin = false}) async {
    final token = await _getValidToken();
    if (token == null || token.isEmpty) {
      final isLoggedIn = _cacheHelper.getData(key: CacheKeys.isLoggedIn) == true;
      if (isLoggedIn) {
        await _expireSession(redirectToLogin: redirectToLogin);
      }
      return false;
    }

    return true;
  }

  Future<_RefreshAttempt> _refreshWithRefreshToken() async {
    final refreshToken =
        _cacheHelper.getData(key: CacheKeys.refreshToken) as String?;
    if (refreshToken == null || refreshToken.isEmpty) {
      return const _RefreshAttempt();
    }

    try {
      final response = await dio.post<dynamic>(
        'Auth/refresh-token',
        data: {'refreshToken': refreshToken},
        options: Options(
          extra: {'_refreshing': true},
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return _RefreshAttempt(
          token: await _storeRefreshedSession(response.data),
        );
      }

      return _RefreshAttempt(rejected: _isRejectedRefreshStatus(response.statusCode));
    } catch (e) {
      if (kDebugMode) debugPrint('Explicit token refresh failed: $e');
    }

    return const _RefreshAttempt();
  }

  bool _isRejectedRefreshStatus(int? statusCode) {
    return statusCode == 400 || statusCode == 401 || statusCode == 403;
  }

  Future<void> _expireSession({bool redirectToLogin = true}) async {
    if (_isExpiringSession) {
      return;
    }

    _isExpiringSession = true;
    try {
      await getIt<AuthViewModel>().logout();
      await getIt<ProfileViewModel>().reset();

      if (!redirectToLogin) {
        return;
      }

      final navigatorKey = getIt<GlobalKey<NavigatorState>>();
      final navigatorState = navigatorKey.currentState;
      if (navigatorState == null) {
        return;
      }

      navigatorState.pushNamedAndRemoveUntil(
        SigninView.routeName,
        (route) => false,
      );
    } finally {
      _isExpiringSession = false;
    }
  }

  Future<Response<dynamic>> postData({
    required String endPoint,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParams,
    bool requiresAuth = false,
  }) async {
    try {
      return await dio.post<dynamic>(
        endPoint,
        data: data,
        queryParameters: queryParams,
        options: Options(
          contentType: Headers.jsonContentType,
          extra: {'requiresAuth': requiresAuth},
        ),
      );
    } on DioException catch (e) {
      throw Exception(_dioConnectionError(e));
    }
  }

  Future<Response<dynamic>> postNoBody({
    required String endPoint,
    bool requiresAuth = false,
  }) async {
    try {
      return await dio.post<dynamic>(
        endPoint,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
    } on DioException catch (e) {
      throw Exception(_dioConnectionError(e));
    }
  }

  Future<Response<dynamic>> getData({
    required String endPoint,
    Map<String, dynamic>? queryParams,
    bool requiresAuth = false,
  }) async {
    try {
      return await dio.get<dynamic>(
        endPoint,
        queryParameters: queryParams,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
    } on DioException catch (e) {
      throw Exception(_dioConnectionError(e));
    }
  }

  Future<Response<dynamic>> postFormData({
    required String endPoint,
    required FormData data,
    Map<String, dynamic>? queryParams,
    bool requiresAuth = false,
  }) async {
    try {
      return await dio.post<dynamic>(
        endPoint,
        data: data,
        queryParameters: queryParams,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
    } on DioException catch (e) {
      throw Exception(_dioConnectionError(e));
    }
  }

  Future<Response<dynamic>> putData({
    required String endPoint,
    required Map<String, dynamic> data,
    bool requiresAuth = false,
  }) async {
    try {
      return await dio.put<dynamic>(
        endPoint,
        data: data,
        options: Options(
          contentType: Headers.jsonContentType,
          extra: {'requiresAuth': requiresAuth},
        ),
      );
    } on DioException catch (e) {
      throw Exception(_dioConnectionError(e));
    }
  }

  Future<Response<dynamic>> putFormData({
    required String endPoint,
    required FormData data,
    Map<String, dynamic>? queryParams,
    bool requiresAuth = false,
  }) async {
    try {
      return await dio.put<dynamic>(
        endPoint,
        data: data,
        queryParameters: queryParams,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
    } on DioException catch (e) {
      throw Exception(_dioConnectionError(e));
    }
  }

  Future<Response<dynamic>> deleteData({
    required String endPoint,
    bool requiresAuth = false,
  }) async {
    try {
      return await dio.delete<dynamic>(
        endPoint,
        options: Options(
          contentType: Headers.jsonContentType,
          extra: {'requiresAuth': requiresAuth},
        ),
      );
    } on DioException catch (e) {
      throw Exception(_dioConnectionError(e));
    }
  }

  Future<Response<dynamic>> deleteWithBody({
    required String endPoint,
    required Map<String, dynamic> data,
    bool requiresAuth = false,
  }) async {
    try {
      return await dio.delete<dynamic>(
        endPoint,
        data: data,
        options: Options(
          contentType: Headers.jsonContentType,
          extra: {'requiresAuth': requiresAuth},
        ),
      );
    } on DioException catch (e) {
      throw Exception(_dioConnectionError(e));
    }
  }
}

// ── Logger interceptor ────────────────────────────────────────────────────────

class _ApiLogger extends Interceptor {
  static final _sep = '─' * 60;
  static const _indent = '  ';

  // Sensitive header keys whose values are masked in logs.
  static const _maskedHeaders = {'authorization', 'x-api-key'};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buf = StringBuffer();
    buf.writeln(_sep);
    buf.writeln('➤ REQUEST');
    buf.writeln('$_indent${options.method}  ${options.uri}');
    buf.writeln('$_indent headers:');
    options.headers.forEach((k, v) {
      final display = _maskedHeaders.contains(k.toLowerCase())
          ? _mask(v.toString())
          : v;
      buf.writeln('$_indent$_indent$k: $display');
    });
    if (options.data != null) {
      buf.writeln('$_indent body:');
      buf.writeln('$_indent$_indent${_prettyJson(options.data)}');
    }
    buf.write(_sep);
    debugPrint(buf.toString());
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final buf = StringBuffer();
    final ok = _isSuccess(response.statusCode);
    buf.writeln(_sep);
    buf.writeln('${ok ? '✔' : '✘'} RESPONSE  [${response.statusCode}]');
    buf.writeln(
      '$_indent${response.requestOptions.method}  ${response.requestOptions.uri}',
    );
    buf.writeln('$_indent body:');
    buf.writeln('$_indent$_indent${_prettyJson(response.data)}');
    buf.write(_sep);
    debugPrint(buf.toString());
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final buf = StringBuffer();
    buf.writeln(_sep);
    buf.writeln('✘ ERROR  [${err.response?.statusCode ?? err.type.name}]');
    buf.writeln(
      '$_indent${err.requestOptions.method}  ${err.requestOptions.uri}',
    );
    buf.writeln('$_indent message: ${err.message}');
    if (err.response?.data != null) {
      buf.writeln('$_indent body:');
      buf.writeln('$_indent$_indent${_prettyJson(err.response?.data)}');
    }
    buf.write(_sep);
    debugPrint(buf.toString());
    handler.next(err);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  bool _isSuccess(int? code) => code != null && code >= 200 && code < 300;

  /// Shows first 6 chars + asterisks so the key is identifiable but not leaked.
  String _mask(String value) {
    if (value.length <= 6) return '***';
    return '${value.substring(0, 6)}${'*' * (value.length - 6)}';
  }

  String _prettyJson(dynamic data) {
    if (data == null) return 'null';
    try {
      final encoder = const JsonEncoder.withIndent('    ');
      if (data is String) {
        final decoded = jsonDecode(data);
        return encoder.convert(decoded);
      }
      return encoder.convert(data);
    } catch (_) {
      return data.toString();
    }
  }
}

// ── Response helper used by all repositories ─────────────────────────────────

/// Extracts a human-readable error message from any response body.
/// Never throws.
String extractResponseError(dynamic data, int? statusCode) {
  final body = _decodeIfString(data);

  if (body is Map) {
    final msg =
        _str(body['message']) ??
        _str(body['Message']) ??
        _str(body['title']) ??
        _str(body['Title']);
    if (msg != null && msg.isNotEmpty) return msg;

    final errors = body['Errors'] ?? body['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final firstErrorValue = errors.values.first;
      if (firstErrorValue is List && firstErrorValue.isNotEmpty) {
        return firstErrorValue.first?.toString() ?? 'Validation error';
      }
      return firstErrorValue.toString();
    }
    if (errors is List && errors.isNotEmpty) {
      return errors.first?.toString() ?? 'Unknown error';
    }
    if (errors is String && errors.isNotEmpty) return errors;
  }

  // Server returned a plain JSON array like ["Invalid OTP"] — take the first item.
  if (body is List && body.isNotEmpty) {
    final first = body.first;
    if (first is String && first.isNotEmpty) return first;
  }

  if (body is String && body.isNotEmpty) return body;

  return 'Server error (${statusCode ?? '?'})';
}

String _dioConnectionError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
      return 'No internet connection. Please check your network and try again.';
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Request timed out. Please try again.';
    case DioExceptionType.badCertificate:
      return 'Secure connection failed. Please try again.';
    case DioExceptionType.cancel:
      return 'Request was cancelled.';
    default:
      return e.message ?? 'An unexpected network error occurred.';
  }
}

dynamic _decodeIfString(dynamic data) {
  if (data is String) {
    try {
      return jsonDecode(data);
    } catch (_) {
      return data;
    }
  }
  return data;
}

String? _str(dynamic v) => v is String ? v : null;

class _RefreshAttempt {
  final String? token;
  final bool rejected;

  const _RefreshAttempt({this.token, this.rejected = false});
}
