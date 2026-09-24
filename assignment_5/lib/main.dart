import 'package:flutter/material.dart';
import 'package:assignment_5/models/todo_item.dart';
import 'package:assignment_5/screens/todo_list_screen.dart';

void main() {
  runApp(const Assignment5App());
}

/// Root widget of Assignment 5 setting up Material 3 theming.
class Assignment5App extends StatelessWidget {
  final List<TodoItem>? initialTodos;

  const Assignment5App({
    super.key,
    this.initialTodos,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment 5 - Todo List (StatefulWidget & setState)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6366F1), // Indigo accent
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1E293B),
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          elevation: 0.5,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      home: TodoListScreen(
        initialTodos: initialTodos,
      ),
    );
  }
}
