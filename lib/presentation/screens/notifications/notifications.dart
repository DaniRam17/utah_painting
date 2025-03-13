import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utah_painting/providers/notification_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.builder(
        itemCount: notificationProvider.notifications.length,
        itemBuilder: (context, index) {
          final notification = notificationProvider.notifications[index];
          return ListTile(
            title: Text(notification['title']!),
            subtitle: Text(notification['message']!),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => notificationProvider.removeNotification(notification['title']!),
            ),
          );
        },
      ),
    );
  }
}