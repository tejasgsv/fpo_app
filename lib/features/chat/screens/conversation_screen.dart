import 'package:flutter/material.dart';

import 'package:fpo_app/core/constants/app_constants.dart';
import 'package:fpo_app/core/constants/app_strings.dart';
import 'package:fpo_app/features/auth/widgets/app_card.dart';
import 'package:fpo_app/features/chat/models/chat_models.dart';
import 'package:fpo_app/features/chat/services/chat_service.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({
    super.key,
    required this.chatService,
    required this.args,
  });

  final ChatService chatService;
  final ChatConversationArgs args;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  late Future<List<ChatMessage>> _messagesFuture;

  @override
  void initState() {
    super.initState();
    _messagesFuture = widget.chatService.fetchMessages(widget.args.threadId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _refreshMessages() async {
    setState(() {
      _messagesFuture = widget.chatService.fetchMessages(widget.args.threadId);
    });
    await _messagesFuture;
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      return;
    }

    _messageController.clear();
    await widget.chatService.sendMessage(threadId: widget.args.threadId, message: message);
    await _refreshMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.args.partnerName),
            Text(widget.args.contextLabel, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Discussion channel'),
                    SizedBox(height: 6),
                    Text('Use this space for crop availability, logistics, and coordination. No payment flow is included.'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ChatMessage>>(
                future: _messagesFuture,
                builder: (context, snapshot) {
                  final messages = snapshot.data ?? const <ChatMessage>[];
                  if (snapshot.connectionState == ConnectionState.waiting && messages.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.screenHorizontalPadding),
                    itemCount: messages.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return Align(
                        alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: message.isMine ? Theme.of(context).colorScheme.primary : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              child: Column(
                                crossAxisAlignment: message.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.body,
                                    style: TextStyle(color: message.isMine ? Colors.white : Colors.black87),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatTime(message.sentAt),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: message.isMine ? Colors.white70 : Theme.of(context).textTheme.bodySmall?.color,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: AppStrings.chatHint,
                        suffixIcon: Icon(Icons.edit_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: AppConstants.buttonMinHeight,
                    child: FilledButton(
                      onPressed: _sendMessage,
                      child: const Icon(Icons.send_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatTime(DateTime dateTime) {
  final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = dateTime.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}