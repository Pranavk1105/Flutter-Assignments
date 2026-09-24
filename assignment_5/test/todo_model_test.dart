import 'package:flutter_test/flutter_test.dart';
import 'package:assignment_5/models/todo_item.dart';

void main() {
  group('TodoItem Model Tests', () {
    test('initializes with expected default values', () {
      final now = DateTime(2026, 9, 19, 10, 30);
      final item = TodoItem(
        id: '101',
        title: 'Learn Flutter',
        createdAt: now,
      );

      expect(item.id, '101');
      expect(item.title, 'Learn Flutter');
      expect(item.description, '');
      expect(item.isCompleted, isFalse);
      expect(item.priority, TodoPriority.medium);
      expect(item.category, TodoCategory.general);
      expect(item.createdAt, now);
    });

    test('copyWith updates fields while preserving unedited values', () {
      final now = DateTime(2026, 9, 19, 10, 30);
      final item = TodoItem(
        id: '101',
        title: 'Original Title',
        description: 'Original Description',
        createdAt: now,
        priority: TodoPriority.low,
        category: TodoCategory.study,
      );

      final updated = item.copyWith(
        title: 'Updated Title',
        isCompleted: true,
        priority: TodoPriority.high,
      );

      expect(updated.id, '101');
      expect(updated.title, 'Updated Title');
      expect(updated.description, 'Original Description');
      expect(updated.isCompleted, isTrue);
      expect(updated.priority, TodoPriority.high);
      expect(updated.category, TodoCategory.study);
    });

    test('formattedDate produces formatted day, month, and time', () {
      final date = DateTime(2026, 9, 19, 14, 5);
      final item = TodoItem(
        id: '1',
        title: 'Test',
        createdAt: date,
      );

      expect(item.formattedDate, '19 Sep, 14:05');
    });

    test('equality and hashCode verify value semantics', () {
      final date = DateTime(2026, 9, 19);
      final item1 = TodoItem(id: '1', title: 'Task', createdAt: date);
      final item2 = TodoItem(id: '1', title: 'Task', createdAt: date);
      final item3 = TodoItem(id: '2', title: 'Task', createdAt: date);

      expect(item1, equals(item2));
      expect(item1.hashCode, equals(item2.hashCode));
      expect(item1, isNot(equals(item3)));
    });
  });
}
