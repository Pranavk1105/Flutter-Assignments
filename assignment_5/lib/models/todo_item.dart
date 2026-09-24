/// Represents the priority of a todo task.
enum TodoPriority {
  low('Low'),
  medium('Medium'),
  high('High');

  final String label;
  const TodoPriority(this.label);
}

/// Represents the functional category of a todo task.
enum TodoCategory {
  general('General'),
  personal('Personal'),
  work('Work'),
  study('Study'),
  health('Health');

  final String label;
  const TodoCategory(this.label);
}

/// Immutable data model representing an individual task in the Todo List.
class TodoItem {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final TodoPriority priority;
  final TodoCategory category;

  const TodoItem({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.priority = TodoPriority.medium,
    this.category = TodoCategory.general,
  });

  /// Returns a copy of this [TodoItem] with updated properties.
  TodoItem copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    TodoPriority? priority,
    TodoCategory? category,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
      category: category ?? this.category,
    );
  }

  /// Formatted creation time string.
  String get formattedDate {
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    final day = createdAt.day.toString().padLeft(2, '0');
    final month = _monthName(createdAt.month);
    return '$day $month, $hour:$minute';
  }

  static String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          isCompleted == other.isCompleted &&
          priority == other.priority &&
          category == other.category;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        description,
        isCompleted,
        priority,
        category,
      );
}
