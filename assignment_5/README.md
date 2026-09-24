# 📝 Assignment 5: Interactive Todo List with StatefulWidget & setState

[![Flutter Version](https://img.shields.io/badge/Flutter-3.47.1-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.13.1-0175C2?logo=dart)](https://dart.dev)
[![Tests Passing](https://img.shields.io/badge/Tests-100%25%20Passed-brightgreen)](https://github.com/Pranavk1105/Flutter-Assignments)
[![Analyzer](https://img.shields.io/badge/flutter%20analyze-0%20issues-blue)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)

A complete Flutter application demonstrating local state management using **`StatefulWidget`** and **`setState()`** to build an interactive, high-performance **Todo List**. The app supports adding new tasks with modal bottom sheets and validation, toggling completion with visual strike-through styling, deleting tasks via swipe-to-dismiss or icon button with an Undo snackbar, task categorization, priority tagging, completion progress tracking, and status filtering.

**Student Name:** Pranav Kale  
**Roll No:** 150096724142  
**Course:** Flutter Application Development (BTech CSE 2024-28)  

---

## 📸 Visual Demo & Output Screenshots

| 1. All Tasks View | 2. Add Task Modal Sheet | 3. Pending Tasks Filter | 4. Completed Tasks Filter |
| :---: | :---: | :---: | :---: |
| ![All Tasks View](docs/screenshots/screenshot_all_tasks.png) | ![Add Task Sheet](docs/screenshots/screenshot_add_sheet.png) | ![Pending Tasks](docs/screenshots/screenshot_pending_tasks.png) | ![Completed Tasks](docs/screenshots/screenshot_completed_tasks.png) |
| *Progress bar, completion metrics, and task tiles with strike-through styling.* | *Modal bottom sheet form with priority & category choice chips.* | *Filtering by Pending tasks with live dynamic tab counts.* | *Filtering by Completed tasks with strikethrough titles.* |

---

- [Features](#-features)
- [Architecture & State Flow](#-architecture--state-flow)
- [Project Structure](#-project-structure)
- [Key Concepts Implemented](#-key-concepts-implemented)
- [State Mutation Operations](#-state-mutation-operations)
- [Automated Testing](#-automated-testing)
- [How to Run](#-how-to-run)
- [Academic Reports](#-academic-reports)

---

## ✨ Features

- **Core State Operations (`setState`)**:
  - **Add Task:** Modal bottom sheet form with task title validation, description, priority selector (Low, Medium, High), and category tags (General, Personal, Work, Study, Health).
  - **Mark Complete / Incomplete:** Interactive checkbox that mutates `isCompleted` with dynamic strike-through styling, updated completion metrics, and animated linear progress.
  - **Delete Task:** Supports both explicit delete icon buttons and touch-friendly swipe-to-delete (`Dismissible`) with red background and trash icon.
  - **Undo Deletion:** Floating `SnackBar` with an "UNDO" action button that restores the deleted task to its exact previous index.
  - **Clear Completed:** Batch delete completed tasks from the AppBar action menu.
- **Task Completion Progress Card**:
  - Real-time linear progress bar displaying completion percentage (`e.g., 75%`) and task counts (`Completed 3 of 4`).
  - Metric chips showing Total, Pending, and Done task counts.
- **Segmented Filter Bar**:
  - Switch effortlessly between **All**, **Pending**, and **Completed** tasks with dynamic badge counts.
- **Real-Time Search**:
  - Instant client-side search filtering by task title or description.
- **Clean Empty States**:
  - Informative illustrations and action prompts when no tasks match the selected filter.
- **Material 3 Design**:
  - Modern Indigo/Violet theme, elevated cards, priority color coding, smooth micro-animations, and responsive layout.
- **100% Passing Automated Tests**:
  - Unit tests for model immutability and `copyWith`.
  - Comprehensive widget tests for add, mark-complete, delete with undo, and status filtering.
- **Zero Lint Warnings**:
  - Clean `flutter analyze` run with 0 errors and 0 warnings.

---

## 🗺️ Architecture & State Flow

```
┌────────────────────────────────────────────────────────┐
│                   TodoListScreen                       │
│              (StatefulWidget & State)                  │
│                                                        │
│  State:                                                │
│  • List<TodoItem> _todos                               │
│  • TodoFilter _currentFilter                           │
│  • String _searchQuery                                 │
└───────────────────────────┬────────────────────────────┘
                            │
      ┌─────────────────────┼─────────────────────┐
      ▼                     ▼                     ▼
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│     _addTodo     │  │ _toggleComplete  │  │   _deleteTodo    │
│                  │  │                  │  │                  │
│ setState(() {    │  │ setState(() {    │  │ setState(() {    │
│  _todos.insert(  │  │  _todos[idx] =   │  │  _todos.removeAt │
│   0, newItem);   │  │   t.copyWith(..);│  │  );              │
│ });              │  │ });              │  │ }); + Undo bar   │
└──────────────────┘  └──────────────────┘  └──────────────────┘
                            │
                            ▼ Triggers Rebuild
┌────────────────────────────────────────────────────────┐
│                    UI Components                       │
│  • TodoStatsCard (Progress & Completed X of Y)         │
│  • Search Bar & FilterBar (All / Pending / Done)       │
│  • ListView with TodoTile widgets                      │
│  • FloatingActionButton -> AddTodoSheet                │
└────────────────────────────────────────────────────────┘
```

---

## 📁 Project Structure

```
assignment_5/
├── lib/
│   ├── main.dart                      # App entry point with Material 3 theming
│   ├── models/
│   │   ├── todo_item.dart             # TodoItem model with copyWith, priorities, & categories
│   │   └── todo_filter.dart           # Enum for status filtering (all, active, completed)
│   ├── screens/
│   │   └── todo_list_screen.dart      # Main StatefulWidget hosting task list & setState operations
│   └── widgets/
│       ├── todo_tile.dart             # Dismissible card widget with checkbox, badges, & delete action
│       ├── todo_stats_card.dart       # Gradient card showing progress bar & task counts
│       ├── add_todo_sheet.dart        # Modal bottom sheet form for creating new tasks
│       ├── filter_bar.dart            # Segmented buttons for filtering (All, Pending, Done)
│       └── empty_todo_view.dart       # Illustrated empty state view
├── test/
│   ├── todo_model_test.dart           # Unit tests for TodoItem model & copyWith logic
│   └── widget_test.dart               # 5 widget tests for add, toggle-complete, delete, and filter
├── docs/
│   ├── report.md                      # Academic assignment report for Pranav Kale
│   └── assignment5_report.html        # Styled printable report
├── Assignment 5 Report - Pranav Kale.pdf # Generated printable PDF report
├── pubspec.yaml                       # Flutter dependencies (cupertino_icons)
└── README.md                          # Full project overview
```

---

## 💡 State Mutation Operations

### 1. Add Todo
```dart
void _addTodo(TodoItem item) {
  setState(() {
    _todos.insert(0, item);
  });
}
```

### 2. Toggle Mark-Complete
```dart
void _toggleTodoComplete(String id, bool? isCompleted) {
  final index = _todos.indexWhere((t) => t.id == id);
  if (index != -1) {
    setState(() {
      _todos[index] = _todos[index].copyWith(
        isCompleted: isCompleted ?? !_todos[index].isCompleted,
      );
    });
  }
}
```

### 3. Delete Todo with Undo
```dart
void _deleteTodo(String id) {
  final index = _todos.indexWhere((t) => t.id == id);
  if (index == -1) return;

  final removed = _todos[index];
  setState(() {
    _todos.removeAt(index);
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Deleted "${removed.title}"'),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () {
          setState(() {
            _todos.insert(index, removed);
          });
        },
      ),
    ),
  );
}
```

---

## 🧪 Automated Testing

Run all unit and widget tests:
```bash
flutter test
```

### Test Coverage (9 Tests Passed):
- `test/todo_model_test.dart` (4 tests):
  - Model initialization with default values
  - Immutability and `copyWith` preservation
  - Date formatting
  - Value equality & hash codes
- `test/widget_test.dart` (5 tests):
  - Rendering initial tasks and completion progress summary
  - Toggling task completion and updating stats
  - Adding a new task via `AddTodoSheet` modal
  - Deleting a task with working `UNDO` action
  - Filtering tasks by `Pending` and `Done` tabs

---

## 🚀 How to Run

1. Open a terminal and enter the project folder:
   ```bash
   cd assignment_5
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run static analysis:
   ```bash
   flutter analyze
   ```
4. Run the application:
   ```bash
   # Run on Chrome
   flutter run -d chrome

   # Or run on macOS
   flutter run -d macos
   ```

---

## 📄 Academic Reports

- Markdown Report: [`docs/report.md`](docs/report.md)
- Printable HTML Report: [`docs/assignment5_report.html`](docs/assignment5_report.html)
- PDF Report: [`Assignment 5 Report - Pranav Kale.pdf`](Assignment%205%20Report%20-%20Pranav%20Kale.pdf)
