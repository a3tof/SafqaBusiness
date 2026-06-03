import 'package:dio/dio.dart';
import 'package:safqaseller/core/network/dio_client.dart';
import 'package:safqaseller/features/chat/model/models/chat_models.dart';

class ChatRepository {
  final DioHelper dioHelper;

  ChatRepository({required this.dioHelper});

  Future<Map<String, dynamic>> createConversation(int disputeId) async {
    final response = await dioHelper.postData(
      endPoint: 'Chat/conversation/$disputeId',
      requiresAuth: true,
      data: {
        'disputeId': disputeId,
      },
    );

    final statusCode = response.statusCode ?? 500;
    if (statusCode < 200 || statusCode >= 300) {
      throw Exception(extractResponseError(response.data, statusCode));
    }

    final data = response.data;
    if (data is Map && data.containsKey('id')) {
      return data as Map<String, dynamic>;
    } else {
      throw Exception('Invalid response format: missing conversation id');
    }
  }

  Future<List<ConversationModel>> getConversations() async {
    final response = await dioHelper.getData(
      endPoint: 'Chat/conversations',
      requiresAuth: true,
    );

    if (_isEmptyCollectionResponse(response, const [
      'no conversations',
      'no chats',
    ])) {
      return [];
    }

    _require(response);
    final list = _asList(response.data);
    if (list == null) {
      throw Exception('Unexpected conversations response format');
    }

    return list
        .map((item) => ConversationModel.fromJson(_asMap(item) ?? {}))
        .toList();
  }

  Future<List<MessageModel>> getMessages(int conversationId) async {
    final response = await dioHelper.getData(
      endPoint: 'Chat/messages',
      queryParams: {'conversationId': conversationId},
      requiresAuth: true,
    );

    if (_isEmptyCollectionResponse(response, const [
      'no messages',
      'no chat',
    ])) {
      return [];
    }

    _require(response);
    final list = _asList(response.data);
    if (list == null) {
      throw Exception('Unexpected messages response format');
    }

    return list
        .map((item) => MessageModel.fromJson(_asMap(item) ?? {}))
        .toList();
  }

  Future<MessageModel> sendMessage({
    required int conversationId,
    required String content,
  }) async {
    final response = await dioHelper.postData(
      endPoint: 'Chat/send',
      data: {'conversationId': conversationId, 'content': content},
      requiresAuth: true,
    );

    _require(response);

    final body = _asMap(response.data);
    if (body != null) {
      final nested = _firstNestedMap(body);
      if (nested != null) {
        return MessageModel.fromJson(nested);
      }
      if (_looksLikeMessage(body)) {
        return MessageModel.fromJson(body);
      }
    }

    return MessageModel(
      id: 0,
      conversationId: conversationId,
      content: content,
      sentAt: DateTime.now(),
      isMine: true,
    );
  }

  void _require(Response<dynamic> response) {
    final code = response.statusCode;
    if (code != null && (code < 200 || code > 299)) {
      throw Exception(extractResponseError(response.data, code));
    }
  }

  bool _isEmptyCollectionResponse(
    Response<dynamic> response,
    List<String> keywords,
  ) {
    if (response.statusCode != 404) return false;
    final message = extractResponseError(
      response.data,
      response.statusCode,
    ).toLowerCase();
    return keywords.any(message.contains);
  }

  bool _looksLikeMessage(Map<String, dynamic> json) {
    return json.containsKey('content') ||
        json.containsKey('Content') ||
        json.containsKey('message') ||
        json.containsKey('Message');
  }

  Map<String, dynamic>? _firstNestedMap(Map<String, dynamic> json) {
    for (final key in const [
      'data',
      'Data',
      'item',
      'Item',
      'messageData',
      'MessageData',
    ]) {
      final value = json[key];
      final map = _asMap(value);
      if (map != null) {
        return map;
      }
    }
    return null;
  }

  Map<String, dynamic>? _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return null;
  }

  List<dynamic>? _asList(dynamic data) {
    if (data is List) return data;
    final body = _asMap(data);
    if (body == null) return null;

    for (final key in const [
      'data',
      'Data',
      'items',
      'Items',
      'messages',
      'Messages',
      'conversations',
      'Conversations',
      'chats',
      'Chats',
    ]) {
      final value = body[key];
      if (value is List) {
        return value;
      }
    }
    return null;
  }
}
