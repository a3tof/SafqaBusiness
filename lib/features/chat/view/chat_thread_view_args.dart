class ChatThreadViewArgs {
  final int conversationId;
  final String buyerName;
  final int? disputeId;

  const ChatThreadViewArgs({
    required this.conversationId,
    required this.buyerName,
    this.disputeId,
  });
}
