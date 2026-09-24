import 'package:flutter/material.dart';
import 'package:assignment_5/models/todo_item.dart';

/// Renders an individual [TodoItem] inside a dismissible card with checkbox,
/// priority badge, category tag, and delete action.
class TodoTile extends StatelessWidget {
  final TodoItem todo;
  final ValueChanged<bool?> onToggleComplete;
  final VoidCallback onDelete;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggleComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDone = todo.isCompleted;

    return Dismissible(
      key: Key('dismissible_${todo.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        elevation: isDone ? 0.3 : 0.8,
        color: isDone ? Colors.grey.shade50 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isDone ? Colors.grey.shade200 : Colors.grey.shade300,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => onToggleComplete(!isDone),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Completion Checkbox
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Checkbox(
                    key: Key('checkbox_${todo.id}'),
                    value: isDone,
                    onChanged: onToggleComplete,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    activeColor: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),

                // Task Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          decoration:
                              isDone ? TextDecoration.lineThrough : null,
                          color: isDone
                              ? Colors.grey.shade500
                              : const Color(0xFF1E293B),
                        ),
                      ),
                      if (todo.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          todo.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            decoration:
                                isDone ? TextDecoration.lineThrough : null,
                            color: isDone
                                ? Colors.grey.shade400
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),

                      // Metadata Tags: Priority & Category
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _buildPriorityBadge(todo.priority),
                          _buildCategoryBadge(todo.category),
                          Text(
                            todo.formattedDate,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Delete Button
                IconButton(
                  key: Key('delete_button_${todo.id}'),
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: Colors.red.shade400,
                  ),
                  tooltip: 'Delete task',
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(TodoPriority priority) {
    final Color color;
    final Color bg;

    switch (priority) {
      case TodoPriority.high:
        color = Colors.red.shade800;
        bg = Colors.red.shade50;
        break;
      case TodoPriority.medium:
        color = Colors.amber.shade900;
        bg = Colors.amber.shade50;
        break;
      case TodoPriority.low:
        color = Colors.green.shade800;
        bg = Colors.green.shade50;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag_rounded, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            priority.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(TodoCategory category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.indigo.shade100),
      ),
      child: Text(
        category.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.indigo.shade800,
        ),
      ),
    );
  }
}
