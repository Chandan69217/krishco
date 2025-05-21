import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChannelPartnerNotificationScreen extends StatelessWidget {
  final List<_NotificationItem> notifications = [
    _NotificationItem(
      title: "New message from John",
      subtitle: "Hey, are we still meeting at 5?",
      icon: Icons.message,
      timestamp: DateTime.now().subtract(Duration(minutes: 10)),
      isRead: false,
    ),
    _NotificationItem(
      title: "Task Completed",
      subtitle: "Your PDF conversion is finished.",
      icon: Icons.check_circle,
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
      isRead: true,
    ),
    _NotificationItem(
      title: "System Update",
      subtitle: "Version 1.2.3 is available.",
      icon: Icons.system_update,
      timestamp: DateTime.now().subtract(Duration(days: 1)),
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(12),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return _NotificationTile(item: item);
        },
      ),
    );
  }
}

class _NotificationItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final DateTime timestamp;
  final bool isRead;

  _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.timestamp,
    required this.isRead,
  });
}

class _NotificationTile extends StatelessWidget {
  final _NotificationItem item;

  _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: item.isRead ? 1 : 3,
      borderRadius: BorderRadius.circular(12),
      color: item.isRead ? Colors.grey[100] : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(item.icon, color: Colors.blue),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Text(item.subtitle),
        trailing: Text(
          DateFormat('hh:mm a').format(item.timestamp),
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        onTap: () {
          // Navigate to detail or mark as read
        },
      ),
    );
  }
}
