import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:safqaseller/core/storage/cache_helper.dart';
import 'package:safqaseller/core/storage/cache_keys.dart';
import 'package:safqaseller/features/notifications/model/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String notificationsRoutePayload = 'notifications';
const String _notificationChannelId = 'safqa_notifications';
const String _notificationChannelName = 'Safqa Notifications';
const String _notificationChannelDescription =
    'Alerts for new notifications from Safqa.';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {}

class NotificationService {
  NotificationService({
    required CacheHelper cacheHelper,
    required GlobalKey<NavigatorState> navigatorKey,
  }) : _cacheHelper = cacheHelper,
       _navigatorKey = navigatorKey;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    _notificationChannelId,
    _notificationChannelName,
    description: _notificationChannelDescription,
    importance: Importance.max,
  );

  final CacheHelper _cacheHelper;
  final GlobalKey<NavigatorState> _navigatorKey;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _openInboxOnLaunch = false;

  Future<void> init() async {
    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    _openInboxOnLaunch = launchDetails?.didNotificationLaunchApp ?? false;

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('ic_stat_notification'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
      ),
    );

    await _plugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await _createNotificationChannel();
  }

  Future<bool> requestPermissions() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final androidGranted =
        await androidPlugin?.requestNotificationsPermission() ?? true;

    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final iosGranted = await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return androidGranted && (iosGranted ?? true);
  }

  bool get isNotificationsEnabled =>
      (_cacheHelper.getData(key: CacheKeys.notificationsEnabled) as bool?) ??
      false;

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _cacheHelper.saveData(
      key: CacheKeys.notificationsEnabled,
      value: enabled,
    );
  }

  Future<void> showNewNotifications(
    List<NotificationModel> notifications,
  ) async {
    if (!isNotificationsEnabled) {
      return;
    }

    final shownIds = readShownNotificationIds(_cacheHelper.sharedPreferences);
    var hasNewIds = false;

    for (final notification in notifications) {
      if (!shownIds.add(notification.id)) {
        continue;
      }

      hasNewIds = true;
      await showNotification(
        id: notification.id,
        title: notification.title,
        body: notification.message,
      );
    }

    if (hasNewIds) {
      await saveShownNotificationIds(_cacheHelper.sharedPreferences, shownIds);
    }
  }

  bool hasUnseenNotifications(List<NotificationModel> notifications) {
    final seenIds = readSeenNotificationIds(_cacheHelper.sharedPreferences);
    return notifications.any((notification) => !seenIds.contains(notification.id));
  }

  Future<void> markNotificationsSeen(Iterable<int> ids) async {
    final seenIds = readSeenNotificationIds(_cacheHelper.sharedPreferences);
    seenIds.addAll(ids);
    await saveSeenNotificationIds(_cacheHelper.sharedPreferences, seenIds);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _plugin.show(
      id: id,
      title: title.isEmpty ? 'Safqa' : title,
      body: body,
      notificationDetails: _notificationDetails(),
      payload: notificationsRoutePayload,
    );
  }

  Future<void> handleInitialNotificationNavigation() async {
    if (!_openInboxOnLaunch) {
      return;
    }

    _openInboxOnLaunch = false;
    _openNotificationsInbox();
  }

  static Future<void> showStandalone({
    required int id,
    required String title,
    required String body,
  }) async {
    final plugin = FlutterLocalNotificationsPlugin();

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('ic_stat_notification'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
      ),
    );

    await plugin.initialize(settings: initializationSettings);

    final androidPlugin = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(_channel);

    await plugin.show(
      id: id,
      title: title.isEmpty ? 'Safqa' : title,
      body: body,
      notificationDetails: _notificationDetails(),
      payload: notificationsRoutePayload,
    );
  }

  static Set<int> readShownNotificationIds(SharedPreferences preferences) {
    final rawValue =
        preferences.getString(CacheKeys.shownNotificationIds) ?? '[]';

    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is List) {
        return decoded
            .map((value) => int.tryParse(value.toString()))
            .whereType<int>()
            .toSet();
      }
    } catch (_) {}

    return <int>{};
  }

  static Set<int> readSeenNotificationIds(SharedPreferences preferences) {
    final rawValue =
        preferences.getString(CacheKeys.seenNotificationIds) ?? '[]';

    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is List) {
        return decoded
            .map((value) => int.tryParse(value.toString()))
            .whereType<int>()
            .toSet();
      }
    } catch (_) {}

    return <int>{};
  }

  static Future<void> saveShownNotificationIds(
    SharedPreferences preferences,
    Set<int> ids,
  ) async {
    final trimmedIds = ids.length > 100
        ? ids.toList().sublist(ids.length - 100)
        : ids.toList();

    await preferences.setString(
      CacheKeys.shownNotificationIds,
      jsonEncode(trimmedIds),
    );
  }

  static Future<void> saveSeenNotificationIds(
    SharedPreferences preferences,
    Set<int> ids,
  ) async {
    final trimmedIds = ids.length > 100
        ? ids.toList().sublist(ids.length - 100)
        : ids.toList();

    await preferences.setString(
      CacheKeys.seenNotificationIds,
      jsonEncode(trimmedIds),
    );
  }

  Future<void> _createNotificationChannel() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(_channel);
  }

  void _handleNotificationResponse(NotificationResponse response) {
    if (response.payload == notificationsRoutePayload) {
      _openNotificationsInbox();
    }
  }

  void _openNotificationsInbox() {
    final navigator = _navigatorKey.currentState;
    if (navigator == null) {
      _openInboxOnLaunch = true;
      return;
    }

    navigator.pushNamed(notificationsRoutePayload);
  }

  static NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _notificationChannelId,
        _notificationChannelName,
        channelDescription: _notificationChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }
}
