import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assignment_5/main.dart';
import 'package:assignment_5/models/todo_item.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  List<TodoItem> getTestTodos() {
    final now = DateTime(2026, 9, 19, 12, 0);
    return [
      TodoItem(
        id: 't1',
        title: 'Complete Assignment 5',
        description: 'Build Todo List using StatefulWidget',
        isCompleted: false,
        createdAt: now,
        priority: TodoPriority.high,
        category: TodoCategory.work,
      ),
      TodoItem(
        id: 't2',
        title: 'Review Flutter Docs',
        description: 'Read about setState',
        isCompleted: true,
        createdAt: now,
        priority: TodoPriority.medium,
        category: TodoCategory.study,
      ),
    ];
  }

  testWidgets('Screen renders initial tasks and progress summary correctly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(Assignment5App(initialTodos: getTestTodos()));
    await tester.pumpAndSettle();

    expect(find.text('Assignment 5'), findsOneWidget);
    expect(find.text('1 of 2 Completed'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);
    expect(find.text('Complete Assignment 5'), findsOneWidget);
    expect(find.text('Review Flutter Docs'), findsOneWidget);
  });

  testWidgets('Toggling task completion updates checkbox and completion stats',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(Assignment5App(initialTodos: getTestTodos()));
    await tester.pumpAndSettle();

    // Currently 1 of 2 completed
    expect(find.text('1 of 2 Completed'), findsOneWidget);

    // Tap checkbox of uncompleted task 't1'
    await tester.tap(find.byKey(const Key('checkbox_t1')));
    await tester.pumpAndSettle();

    // Now both tasks are completed: 2 of 2
    expect(find.text('2 of 2 Completed'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);

    // Tap checkbox again to uncheck
    await tester.tap(find.byKey(const Key('checkbox_t1')));
    await tester.pumpAndSettle();

    expect(find.text('1 of 2 Completed'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);
  });

  testWidgets('Adding a new task via AddTodoSheet inserts it into state and list',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(Assignment5App(initialTodos: getTestTodos()));
    await tester.pumpAndSettle();

    // Tap FAB to open Add Task modal sheet
    await tester.tap(find.byKey(const Key('add_task_fab')));
    await tester.pumpAndSettle();

    expect(find.text('Add New Task'), findsOneWidget);

    // Enter title & description
    await tester.enterText(
        find.byKey(const Key('add_todo_title_field')), 'Submit Report');
    await tester.enterText(
        find.byKey(const Key('add_todo_desc_field')), 'PDF format required');

    // Submit
    await tester.tap(find.byKey(const Key('submit_new_todo_button')));
    await tester.pumpAndSettle();

    // Verify task is inserted into list and progress updated
    expect(find.text('Submit Report'), findsOneWidget);
    expect(find.text('PDF format required'), findsOneWidget);
    expect(find.text('1 of 3 Completed'), findsOneWidget);
  });

  testWidgets('Deleting a task removes it from state with working undo action',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(Assignment5App(initialTodos: getTestTodos()));
    await tester.pumpAndSettle();

    expect(find.text('Complete Assignment 5'), findsOneWidget);

    // Tap delete button on t1
    await tester.tap(find.byKey(const Key('delete_button_t1')));
    await tester.pumpAndSettle();

    // t1 is deleted
    expect(find.text('Complete Assignment 5'), findsNothing);
    expect(find.text('Deleted "Complete Assignment 5"'), findsOneWidget);
    expect(find.text('UNDO'), findsOneWidget);

    // Tap UNDO
    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();

    // t1 is restored
    expect(find.text('Complete Assignment 5'), findsOneWidget);
  });

  testWidgets('Filter tabs switch between All, Pending, and Completed tasks',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(Assignment5App(initialTodos: getTestTodos()));
    await tester.pumpAndSettle();

    // In All tab: both visible
    expect(find.text('Complete Assignment 5'), findsOneWidget);
    expect(find.text('Review Flutter Docs'), findsOneWidget);

    // Tap 'Pending' tab
    await tester.tap(find.text('Pending (1)'));
    await tester.pumpAndSettle();

    // Only active task is visible
    expect(find.text('Complete Assignment 5'), findsOneWidget);
    expect(find.text('Review Flutter Docs'), findsNothing);

    // Tap 'Done' tab
    await tester.tap(find.text('Done (1)'));
    await tester.pumpAndSettle();

    // Only completed task is visible
    expect(find.text('Complete Assignment 5'), findsNothing);
    expect(find.text('Review Flutter Docs'), findsOneWidget);
  });
}
