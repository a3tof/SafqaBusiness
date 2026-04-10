import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:safqaseller/core/config/app_config.dart';
import 'package:safqaseller/core/services/notification_service.dart';
import 'package:safqaseller/core/storage/cache_keys.dart';
import 'package:safqaseller/features/notifications/model/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

const String notificationSyncTaskId =
    'com.example.safqaseller.notification_sync';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    if (task != notificationSyncTaskId &&
        task != Workmanager.iOSBackgroundTask) {
      return true;
    }

    try {
      final preferences = await SharedPreferences.getInstance();
      final token = preferences.getString(CacheKeys.token);
      final deviceId = preferences.getString(CacheKeys.deviceId);
      final notificationsEnabled =
          preferences.getBool(CacheKeys.notificationsEnabled) ?? false;

      if (!notificationsEnabled) {
        return true;
      }

      if (token == null || token.isEmpty) {
        return true;
      }

      final dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          receiveDataWhenStatusError: true,
          validateStatus: (_) => true,
          headers: {'x-api-key': AppConfig.apiKey},
        ),
      );

      var accessToken = token;
      final tokenTime = preferences.getString(CacheKeys.tokenTime);
      if (_shouldRefreshToken(tokenTime)) {
        accessToken = await _refreshToken(
              dio: dio,
              preferences: preferences,
              expiredToken: accessToken,
            ) ??
            accessToken;
      }

      var response = await _fetchNotifications(
        dio: dio,
        deviceId: deviceId,
        accessToken: accessToken,
      );

      if (response.statusCode == 401) {
        final refreshedToken = await _refreshToken(
          dio: dio,
          preferences: preferences,
          expiredToken: accessToken,
        );

        if (refreshedToken == null) {
          return true;
        }

        response = await _fetchNotifications(
          dio: dio,
          deviceId: deviceId,
          accessToken: refreshedToken,
        );
      }

      if (!_isSuccess(response.statusCode)) {
        return true;
      }

      final responseData = _decodeIfString(response.data);
      if (responseData is! List) {
        return true;
      }

      final notifications =
          responseData
              .whereType<Map>()
              .map((entry) => NotificationModel.fromJson(Map<String, dynamic>.from(entry)))
              .toList();

      final shownIds = NotificationService.readShownNotificationIds(
        preferences,
      );
      var hasNewIds = false;

      for (final notification in notifications) {
        if (!shownIds.add(notification.id)) {
          continue;
        }

        hasNewIds = true;
        await NotificationService.showStandalone(
          id: notification.id,
          title: notification.title,
          body: notification.message,
        );
      }

      if (hasNewIds) {
        await NotificationService.saveShownNotificationIds(preferences, shownIds);
      }
    } catch (_) {
      return true;
    }

    return true;
  });
}

Future<Response<dynamic>> _fetchNotifications({
  required Dio dio,
  required String? deviceId,
  required String accessToken,
}) {
  return dio.get<dynamic>(
    'Notifications/Get-Notifications',
    options: Options(
      headers: {
        'Authorization': 'Bearer $accessToken',
        if (deviceId != null && deviceId.isNotEmpty) 'DeviceId': deviceId,
      },
    ),
  );
}

bool _shouldRefreshToken(String? tokenTime) {
  if (tokenTime == null || tokenTime.isEmpty) {
    return false;
  }

  final parsed = DateTime.tryParse(tokenTime);
  if (parsed == null) {
    return false;
  }

  return DateTime.now().difference(parsed).inHours >= 5;
}

Future<String?> _refreshToken({
  required Dio dio,
  required SharedPreferences preferences,
  required String expiredToken,
}) async {
  final response = await dio.post<dynamic>(
    'Auth/refresh-token',
    data: jsonEncode(expiredToken),
    options: Options(contentType: Headers.jsonContentType),
  );

  if (!_isSuccess(response.statusCode)) {
    return null;
  }

  final body = _decodeIfString(response.data);
  if (body is! Map) {
    return null;
  }

  final newToken = (body['token'] ?? body['Token']) as String?;
  if (newToken == null || newToken.isEmpty) {
    return null;
  }

  await preferences.setString(CacheKeys.token, newToken);
  await preferences.setString(
    CacheKeys.tokenTime,
    DateTime.now().toIso8601String(),
  );

  final newRefreshToken = (body['refreshToken'] ?? body['RefreshToken']) as String?;
  if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
    await preferences.setString(CacheKeys.refreshToken, newRefreshToken);
  }

  return newToken;
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

bool _isSuccess(int? statusCode) {
  return statusCode != null && statusCode >= 200 && statusCode < 300;
}
