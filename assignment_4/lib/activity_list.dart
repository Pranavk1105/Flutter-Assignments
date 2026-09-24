import 'package:flutter/material.dart';
import 'activity_item.dart';

class ActivityList extends StatelessWidget {
  final List<ActivityItem> items;

  const ActivityList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) => ActivityTile(item: items[index]),
      ),
    );
  }
}
