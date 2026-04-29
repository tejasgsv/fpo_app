import '../models/chat_models.dart';

abstract class ChatService {
  Future<List<ChatThread>> fetchThreads();

  Future<List<ChatMessage>> fetchMessages(String threadId);

  Future<ChatThread> startConversation({
    required String partnerName,
    required String contextLabel,
  });

  Future<void> sendMessage({
    required String threadId,
    required String message,
  });
}

class MockChatService implements ChatService {
  MockChatService()
      : _threads = [
          ChatThread(
            id: 'thread_1',
            partnerName: 'Sahyadri FPO',
            contextLabel: 'Organic Wheat',
            lastMessage: 'Please share the crop inspection note.',
            updatedAt: DateTime(2026, 4, 29, 10, 30),
            unreadCount: 2,
          ),
          ChatThread(
            id: 'thread_2',
            partnerName: 'Krushi Mitra FPO',
            contextLabel: 'Fresh Tomato',
            lastMessage: 'We can schedule pickup tomorrow morning.',
            updatedAt: DateTime(2026, 4, 28, 15, 15),
            unreadCount: 0,
          ),
        ] {
    _messages = {
      'thread_1': [
        ChatMessage(
          id: 'message_1',
          threadId: 'thread_1',
          senderName: 'Sahyadri FPO',
          body: 'Is the wheat available for weekly supply?',
          sentAt: DateTime(2026, 4, 29, 9, 40),
          isMine: false,
        ),
        ChatMessage(
          id: 'message_2',
          threadId: 'thread_1',
          senderName: 'You',
          body: 'Yes, we can share quality details and quantity.',
          sentAt: DateTime(2026, 4, 29, 9, 48),
          isMine: true,
        ),
      ],
      'thread_2': [
        ChatMessage(
          id: 'message_3',
          threadId: 'thread_2',
          senderName: 'Krushi Mitra FPO',
          body: 'Pickup logistics are being checked with the cluster lead.',
          sentAt: DateTime(2026, 4, 28, 14, 20),
          isMine: false,
        ),
      ],
    };
  }

  final List<ChatThread> _threads;
  late final Map<String, List<ChatMessage>> _messages;

  @override
  Future<ChatThread> startConversation({
    required String partnerName,
    required String contextLabel,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final existingIndex = _threads.indexWhere(
      (thread) => thread.partnerName == partnerName && thread.contextLabel == contextLabel,
    );
    if (existingIndex != -1) {
      return _threads[existingIndex];
    }

    final thread = ChatThread(
      id: 'thread_${DateTime.now().millisecondsSinceEpoch}',
      partnerName: partnerName,
      contextLabel: contextLabel,
      lastMessage: 'Conversation started.',
      updatedAt: DateTime.now(),
      unreadCount: 0,
    );
    _threads.insert(0, thread);
    _messages[thread.id] = [
      ChatMessage(
        id: 'message_${DateTime.now().millisecondsSinceEpoch}',
        threadId: thread.id,
        senderName: partnerName,
        body: 'Conversation started for $contextLabel.',
        sentAt: DateTime.now(),
        isMine: false,
      ),
    ];
    return thread;
  }

  @override
  Future<List<ChatMessage>> fetchMessages(String threadId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List<ChatMessage>.unmodifiable(_messages[threadId] ?? const []);
  }

  @override
  Future<List<ChatThread>> fetchThreads() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List<ChatThread>.unmodifiable(_threads);
  }

  @override
  Future<void> sendMessage({
    required String threadId,
    required String message,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final threadIndex = _threads.indexWhere((thread) => thread.id == threadId);
    if (threadIndex == -1) {
      return;
    }

    final thread = _threads[threadIndex];
    final updatedThread = ChatThread(
      id: thread.id,
      partnerName: thread.partnerName,
      contextLabel: thread.contextLabel,
      lastMessage: message,
      updatedAt: DateTime.now(),
      unreadCount: 0,
    );
    _threads[threadIndex] = updatedThread;
    final messages = _messages.putIfAbsent(threadId, () => <ChatMessage>[]);
    messages.add(
      ChatMessage(
        id: 'message_${DateTime.now().millisecondsSinceEpoch}',
        threadId: threadId,
        senderName: 'You',
        body: message,
        sentAt: DateTime.now(),
        isMine: true,
      ),
    );
  }
}