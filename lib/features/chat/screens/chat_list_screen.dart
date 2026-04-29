import 'package:flutter/material.dart';

import 'package:fpo_app/core/constants/app_constants.dart';
import 'package:fpo_app/core/constants/app_routes.dart';
import 'package:fpo_app/core/constants/app_strings.dart';
import 'package:fpo_app/features/auth/widgets/app_card.dart';
import 'package:fpo_app/features/chat/models/chat_models.dart';
import 'package:fpo_app/features/chat/services/chat_service.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key, required this.chatService});

  final ChatService chatService;

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late Future<List<ChatThread>> _threadsFuture;

  @override
  void initState() {
    super.initState();
    _threadsFuture = widget.chatService.fetchThreads();
  }

  Future<void> _refreshThreads() async {
    setState(() {
      _threadsFuture = widget.chatService.fetchThreads();
    });
    await _threadsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.communicationTitle)),
      body: RefreshIndicator(
        onRefresh: _refreshThreads,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.communicationTitle, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        const Text(AppStrings.communicationIntro),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<ChatThread>>(
                    future: _threadsFuture,
                    builder: (context, snapshot) {
                      final threads = snapshot.data ?? const <ChatThread>[];
                      if (snapshot.connectionState == ConnectionState.waiting && threads.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (threads.isEmpty) {
                        return AppCard(child: Text(AppStrings.noChatsYet));
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: threads.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final thread = threads[index];
                          return AppCard(
                            child: InkWell(
                              onTap: () async {
                                await Navigator.of(context).pushNamed(
                                  AppRoutes.conversation,
                                  arguments: ChatConversationArgs(
                                    threadId: thread.id,
                                    partnerName: thread.partnerName,
                                    contextLabel: thread.contextLabel,
                                  ),
                                );
                                await _refreshThreads();
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                                        child: Text(thread.partnerName.isNotEmpty ? thread.partnerName[0].toUpperCase() : '?'),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(thread.partnerName, style: Theme.of(context).textTheme.titleMedium),
                                            const SizedBox(height: 4),
                                            Text(thread.contextLabel),
                                          ],
                                        ),
                                      ),
                                      if (thread.unreadCount > 0)
                                        Chip(label: Text('${thread.unreadCount}')),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(thread.lastMessage),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}