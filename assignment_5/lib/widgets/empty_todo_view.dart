import 'package:flutter/material.dart';
import 'package:assignment_5/models/todo_filter.dart';

/// Displayed when the todo list contains no items under the current filter.
class EmptyTodoView extends StatelessWidget {
  final TodoFilter filter;
  final VoidCallback onAddTask;

  const EmptyTodoView({
    super.key,
    required this.filter,
    required this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String title;
    final String subtitle;
    final IconData icon;

    switch (filter) {
      case TodoFilter.all:
        title = 'No Tasks Yet';
        subtitle = 'You have no tasks in your list. Tap the button below to add your first task!';
        icon = Icons.assignment_outlined;
        break;
      case TodoFilter.active:
        title = 'All Caught Up!';
        subtitle = 'Great job! You have no pending tasks remaining.';
        icon = Icons.task_alt_rounded;
        break;
      case TodoFilter.completed:
        title = 'No Completed Tasks';
        subtitle = 'Mark tasks as complete to see them in this archive.';
        icon = Icons.check_circle_outline_rounded;
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 54,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              key: const Key('empty_add_task_button'),
              onPressed: onAddTask,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add a Task'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
