import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/core/services/notification_service.dart';
import 'package:safqaseller/features/notifications/model/repositories/notifications_repository.dart';
import 'package:safqaseller/features/notifications/view_model/notifications/notifications_view_model_state.dart';

class NotificationsViewModel extends Cubit<NotificationsState> {
  final NotificationsRepository notificationsRepository;
  final NotificationService notificationService;

  NotificationsViewModel(this.notificationsRepository, this.notificationService)
      : super(NotificationsInitial());

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadNotifications() async {
    emit(NotificationsLoading());
    try {
      final notifications = await notificationsRepository.getNotifications();
      emit(NotificationsSuccess(notifications: notifications));
      try {
        await notificationService.showNewNotifications(notifications);
      } catch (_) {}
    } catch (e) {
      emit(NotificationsError(_clean(e)));
    }
  }

  // ── Delete selected (no re-fetch — remove from state immediately) ─────────

  Future<void> deleteNotifications(List<int> ids) async {
    final current = state;
    if (current is! NotificationsSuccess) return;

    // Optimistic removal
    final remaining =
        current.notifications.where((n) => !ids.contains(n.id)).toList();
    emit(NotificationsSuccess(notifications: remaining));

    try {
      await notificationsRepository.deleteNotifications(ids);
    } catch (e) {
      // Rollback if the API call fails
      emit(current);
      emit(NotificationsError(_clean(e)));
    }
  }

  // ── Mark read helpers (local state only) ──────────────────────────────────

  Future<void> markNotificationSeenAndRead(int notificationId) async {
    final current = state;
    if (current is! NotificationsSuccess) return;

    await notificationService.markNotificationsSeen([notificationId]);
    final updated = current.notifications.map((notification) {
      return notification.id == notificationId
          ? notification.copyWith(isRead: true)
          : notification;
    }).toList();
    emit(NotificationsSuccess(notifications: updated));
  }

  void markAsRead(int notificationId) {
    final current = state;
    if (current is NotificationsSuccess) {
      final updated = current.notifications.map((n) {
        return n.id == notificationId ? n.copyWith(isRead: true) : n;
      }).toList();
      emit(NotificationsSuccess(notifications: updated));
    }
  }

  Future<void> markAllAsRead() async {
    final current = state;
    if (current is NotificationsSuccess) {
      await notificationService.markNotificationsSeen(
        current.notifications.map((notification) => notification.id),
      );
      final updated =
          current.notifications.map((n) => n.copyWith(isRead: true)).toList();
      emit(NotificationsSuccess(notifications: updated));
    }
  }

  Future<void> markAllAsSeen() async {
    final current = state;
    if (current is NotificationsSuccess) {
      await notificationService.markNotificationsSeen(
        current.notifications.map((notification) => notification.id),
      );
      emit(NotificationsSuccess(notifications: List.of(current.notifications)));
    }
  }

  int get unreadCount {
    final current = state;
    if (current is NotificationsSuccess) {
      return current.notifications.where((n) => !n.isRead).length;
    }
    return 0;
  }

  bool get hasUnreadOrUnseen {
    final current = state;
    if (current is NotificationsSuccess) {
      return notificationService.hasUnseenNotifications(current.notifications);
    }
    return false;
  }

  String _clean(Object e) {
    String msg = e.toString();
    if (msg.startsWith('Exception: ')) msg = msg.replaceFirst('Exception: ', '');
    return msg;
  }
}
