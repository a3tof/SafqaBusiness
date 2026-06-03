class ConversationModel {
  final int id;
  final String buyerName;
  final String? buyerAvatarUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  const ConversationModel({
    required this.id,
    required this.buyerName,
    required this.buyerAvatarUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: _toInt(
        json['id'] ??
            json['Id'] ??
            json['conversationId'] ??
            json['ConversationId'] ??
            json['chatId'] ??
            json['ChatId'],
      ),
      buyerName:
          (json['buyerName'] ??
                  json['BuyerName'] ??
                  json['userName'] ??
                  json['UserName'] ??
                  json['customerName'] ??
                  json['CustomerName'] ??
                  json['title'] ??
                  json['Title'] ??
                  json['name'] ??
                  json['Name'] ??
                  'Conversation')
              .toString(),
      buyerAvatarUrl:
          (json['buyerAvatarUrl'] ??
                  json['BuyerAvatarUrl'] ??
                  json['avatarUrl'] ??
                  json['AvatarUrl'] ??
                  json['imageUrl'] ??
                  json['ImageUrl'] ??
                  json['avatar'] ??
                  json['Avatar'])
              ?.toString(),
      lastMessage:
          (json['lastMessage'] ??
                  json['LastMessage'] ??
                  json['preview'] ??
                  json['Preview'] ??
                  json['message'] ??
                  json['Message'] ??
                  '')
              .toString(),
      lastMessageTime: _toDateTime(
        json['lastMessageTime'] ??
            json['LastMessageTime'] ??
            json['updatedAt'] ??
            json['UpdatedAt'] ??
            json['createdAt'] ??
            json['CreatedAt'] ??
            json['date'] ??
            json['Date'],
      ),
      unreadCount: _toInt(
        json['unreadCount'] ??
            json['UnreadCount'] ??
            json['unreadMessages'] ??
            json['UnreadMessages'] ??
            0,
      ),
    );
  }
}

class MessageModel {
  final int id;
  final int conversationId;
  final String content;
  final DateTime sentAt;
  final bool isMine;
  final bool isPending;
  final String? senderName;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.sentAt,
    required this.isMine,
    this.isPending = false,
    this.senderName,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final rawSender =
        (json['senderType'] ??
                json['SenderType'] ??
                json['senderRole'] ??
                json['SenderRole'] ??
                '')
            .toString()
            .toLowerCase();

    final isMine =
        (json['isMine'] ??
                json['IsMine'] ??
                json['isSender'] ??
                json['IsSender']) ==
            true ||
        rawSender.contains('seller') ||
        rawSender.contains('me');

    return MessageModel(
      id: _toInt(json['id'] ?? json['Id']),
      conversationId: _toInt(
        json['conversationId'] ??
            json['ConversationId'] ??
            json['chatId'] ??
            json['ChatId'],
      ),
      content:
          (json['content'] ??
                  json['Content'] ??
                  json['message'] ??
                  json['Message'] ??
                  json['text'] ??
                  json['Text'] ??
                  '')
              .toString(),
      sentAt: _toDateTime(
        json['sentAt'] ??
            json['SentAt'] ??
            json['createdAt'] ??
            json['CreatedAt'] ??
            json['date'] ??
            json['Date'],
      ),
      isMine: isMine,
      senderName: (json['senderName'] ?? json['SenderName'])?.toString(),
    );
  }

  MessageModel copyWith({
    int? id,
    int? conversationId,
    String? content,
    DateTime? sentAt,
    bool? isMine,
    bool? isPending,
    String? senderName,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      content: content ?? this.content,
      sentAt: sentAt ?? this.sentAt,
      isMine: isMine ?? this.isMine,
      isPending: isPending ?? this.isPending,
      senderName: senderName ?? this.senderName,
    );
  }
}

DateTime _toDateTime(dynamic value) {
  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value) ?? DateTime.now();
  }
  return DateTime.now();
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
