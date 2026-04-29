class ChatThread {
  const ChatThread({
    required this.id,
    required this.partnerName,
    required this.contextLabel,
    required this.lastMessage,
    required this.updatedAt,
    required this.unreadCount,
  });

  final String id;
  final String partnerName;
  final String contextLabel;
  final String lastMessage;
  final DateTime updatedAt;
  final int unreadCount;
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.threadId,
    required this.senderName,
    required this.body,
    required this.sentAt,
    required this.isMine,
  });

  final String id;
  final String threadId;
  final String senderName;
  final String body;
  final DateTime sentAt;
  final bool isMine;
}

class ChatConversationArgs {
  const ChatConversationArgs({
    required this.threadId,
    required this.partnerName,
    required this.contextLabel,
  });

  final String threadId;
  final String partnerName;
  final String contextLabel;
}