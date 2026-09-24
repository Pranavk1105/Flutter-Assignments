import 'package:flutter/material.dart';
import 'package:assignment_5/models/todo_filter.dart';

/// Interactive segmented filter bar allowing users to switch between
/// All, Pending, and Completed tasks.
class FilterBar extends StatelessWidget {
  final TodoFilter selectedFilter;
  final ValueChanged<TodoFilter> onFilterChanged;
  final int allCount;
  final int activeCount;
  final int completedCount;

  const FilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.allCount,
    required this.activeCount,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SegmentedButton<TodoFilter>(
        segments: [
          ButtonSegment(
            value: TodoFilter.all,
            label: Text('All ($allCount)'),
            icon: const Icon(Icons.list_alt_rounded, size: 16),
          ),
          ButtonSegment(
            value: TodoFilter.active,
            label: Text('Pending ($activeCount)'),
            icon: const Icon(Icons.pending_actions_rounded, size: 16),
          ),
          ButtonSegment(
            value: TodoFilter.completed,
            label: Text('Done ($completedCount)'),
            icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
          ),
        ],
        selected: {selectedFilter},
        onSelectionChanged: (newSelection) {
          onFilterChanged(newSelection.first);
        },
      ),
    );
  }
}
