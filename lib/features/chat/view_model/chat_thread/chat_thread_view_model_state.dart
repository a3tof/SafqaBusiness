import 'package:equatable/equatable.dart';
import 'package:safqaseller/features/chat/model/models/chat_models.dart';

abstract class ChatThreadState extends Equatable {
  const ChatThreadState();

  @override
  List<Object?> get props => [];
}

class ChatThreadInitial extends ChatThreadState {}

class ChatThreadLoading extends ChatThreadState {}

class ChatThreadSuccess extends ChatThreadState {
  final int conversationId;
  final List<MessageModel> messages;
  final bool isSending;
  final String? sendErrorMessage;
  final String? disputeReason;
  final String? currentBuyerId;
  final String? currentSellerId;

  const ChatThreadSuccess({
    required this.conversationId,
    required this.messages,
    this.isSending = false,
    this.sendErrorMessage,
    this.disputeReason,
    this.currentBuyerId,
    this.currentSellerId,
  });

  ChatThreadSuccess copyWith({
    int? conversationId,
    List<MessageModel>? messages,
    bool? isSending,
    Object? sendErrorMessage = _sentinel,
    String? disputeReason,
    String? currentBuyerId,
    String? currentSellerId,
  }) {
    return ChatThreadSuccess(
      conversationId: conversationId ?? this.conversationId,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      sendErrorMessage: identical(sendErrorMessage, _sentinel)
          ? this.sendErrorMessage
          : sendErrorMessage as String?,
      disputeReason: disputeReason ?? this.disputeReason,
      currentBuyerId: currentBuyerId ?? this.currentBuyerId,
      currentSellerId: currentSellerId ?? this.currentSellerId,
    );
  }

  @override
  List<Object?> get props => [
    conversationId,
    messages,
    isSending,
    sendErrorMessage,
    disputeReason,
    currentBuyerId,
    currentSellerId,
  ];
}

class ChatThreadFailure extends ChatThreadState {
  final String message;

  const ChatThreadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

const Object _sentinel = Object();
