import 'package:flutter/material.dart';

class ActivityItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const ActivityItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class ActivityTile extends StatelessWidget {
  final ActivityItem item;

  const ActivityTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
        child: Icon(item.icon, color: Colors.deepPurple, size: 20),
      ),
      title: Text(item.title),
      subtitle: Text(item.subtitle),
    );
  }
}
