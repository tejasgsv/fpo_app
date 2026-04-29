import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_routes.dart';
import '../../auth/widgets/app_card.dart';
import '../../chat/models/chat_models.dart';
import '../services/admin_service.dart';

class AdminChatMonitoringScreen extends StatefulWidget {
  const AdminChatMonitoringScreen({super.key, required this.adminService});

  final AdminService adminService;

  @override
  State<AdminChatMonitoringScreen> createState() => _AdminChatMonitoringScreenState();
}

class _AdminChatMonitoringScreenState extends State<AdminChatMonitoringScreen> {
  late Future<List<ChatThread>> _threadsFuture;

  @override
  void initState() {
    super.initState();
    _threadsFuture = widget.adminService.fetchThreads();
  }

  Future<void> _refresh() async {
    setState(() {
      _threadsFuture = widget.adminService.fetchThreads();
    });
    await _threadsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Communication Control')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1020),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Chat Monitoring', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        const Text('Monitor open channels for logistics, crop coordination, and support.'),
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
                        return const AppCard(child: Text('No monitored conversations yet.'));
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: threads.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final thread = threads[index];
                          return AppCard(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.conversation,
                                  arguments: ChatConversationArgs(
                                    threadId: thread.id,
                                    partnerName: thread.partnerName,
                                    contextLabel: thread.contextLabel,
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                                        child: Text(thread.partnerName[0].toUpperCase()),
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
                                      if (thread.unreadCount > 0) Chip(label: Text('${thread.unreadCount} unread')),
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
