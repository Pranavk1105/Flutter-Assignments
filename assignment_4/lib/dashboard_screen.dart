import 'package:flutter/material.dart';
import 'stat_item.dart';
import 'stats_grid.dart';
import 'activity_item.dart';
import 'activity_list.dart';
import 'quick_actions.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const _stats = [
    StatItem(label: 'Revenue', value: '\$12.4k', icon: Icons.attach_money, color: Colors.green),
    StatItem(label: 'Orders', value: '482', icon: Icons.shopping_bag, color: Colors.deepPurple),
    StatItem(label: 'Visitors', value: '9.1k', icon: Icons.people, color: Colors.orange),
    StatItem(label: 'Returns', value: '13', icon: Icons.undo, color: Colors.redAccent),
  ];

  static const _activity = [
    ActivityItem(title: 'New order #1042', subtitle: '2 minutes ago', icon: Icons.shopping_cart),
    ActivityItem(title: 'Payment received', subtitle: '18 minutes ago', icon: Icons.payment),
    ActivityItem(title: 'Refund issued', subtitle: '1 hour ago', icon: Icons.undo),
    ActivityItem(title: 'New review posted', subtitle: '3 hours ago', icon: Icons.star_rate),
    ActivityItem(title: 'Stock low: Blue Mug', subtitle: '5 hours ago', icon: Icons.warning_amber),
  ];

  static const _actions = [
    QuickAction(label: 'Add', icon: Icons.add_box),
    QuickAction(label: 'Order', icon: Icons.receipt_long),
    QuickAction(label: 'Export', icon: Icons.file_download),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 700;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const QuickActionsBar(actions: _actions),
            const SizedBox(height: 16),
            Expanded(
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: StatsGrid(stats: _stats),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: ActivityList(items: _activity),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 260,
                          child: StatsGrid(stats: _stats),
                        ),
                        const SizedBox(height: 16),
                        Expanded(child: ActivityList(items: _activity)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
