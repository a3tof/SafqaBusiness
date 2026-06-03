import 'package:intl/intl.dart';

enum NotificationType { auctionReminder, newAuction, report, orderOnTheWay }

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String timeAgo;
  final NotificationType type;
  final bool isRead;
  final bool hasAction;
  final String? actionLabel;
  final int? conversationId;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
    this.hasAction = false,
    this.actionLabel,
    this.conversationId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final rawType =
        ((json['type'] ?? json['Type'] ?? '') as String).toLowerCase();

    NotificationType type;
    if (rawType.contains('auction')) {
      type = NotificationType.newAuction;
    } else if (rawType.contains('report') || rawType.contains('dispute')) {
      type = NotificationType.report;
    } else if (rawType.contains('order') || rawType.contains('delivery')) {
      type = NotificationType.orderOnTheWay;
    } else {
      type = NotificationType.auctionReminder;
    }

    final rawCreatedAt =
        json['createdAt'] ?? json['CreatedAt'] ?? json['created_at'];
    final timeAgo = _formatTimeAgo(rawCreatedAt as String?);

    int? parsedConversationId;
    final convIdRaw = json['conversationId'] ?? json['ConversationId'] ?? json['referenceId'] ?? json['ReferenceId'];
    if (convIdRaw != null) {
      parsedConversationId = int.tryParse(convIdRaw.toString());
    }

    return NotificationModel(
      id: (json['id'] ?? json['Id'] ?? 0) as int,
      title: (json['title'] ?? json['Title'] ?? '') as String,
      message: (json['message'] ?? json['Message'] ?? '') as String,
      timeAgo: timeAgo,
      type: type,
      isRead: (json['isRead'] ?? json['IsRead'] ?? false) as bool,
      conversationId: parsedConversationId,
    );
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      timeAgo: timeAgo,
      type: type,
      isRead: isRead ?? this.isRead,
      hasAction: hasAction,
      actionLabel: actionLabel,
      conversationId: conversationId,
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  static String _formatTimeAgo(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      final dt = DateTime.parse(rawDate);
      final diff = DateTime.now().difference(dt);
      final locale = Intl.getCurrentLocale();
      final isArabic = locale.toLowerCase().startsWith('ar');
      if (diff.inSeconds < 60) {
        return isArabic ? 'الآن' : 'Just now';
      }
      if (diff.inMinutes < 60) {
        return isArabic
            ? 'منذ ${diff.inMinutes} دقيقة'
            : '${diff.inMinutes} min ago';
      }
      if (diff.inHours < 24) {
        return isArabic ? 'منذ ${diff.inHours} ساعة' : '${diff.inHours} hr ago';
      }
      return isArabic ? 'منذ ${diff.inDays} يوم' : '${diff.inDays} day(s) ago';
    } catch (_) {
      return '';
    }
  }
}
