import 'package:flutter/material.dart';
import 'stat_item.dart';

class StatsGrid extends StatelessWidget {
  final List<StatItem> stats;

  const StatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / 170).floor().clamp(2, 4);
        return GridView.builder(
          itemCount: stats.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemBuilder: (context, index) => StatCard(stat: stats[index]),
        );
      },
    );
  }
}
