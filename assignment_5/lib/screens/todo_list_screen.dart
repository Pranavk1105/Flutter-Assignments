import 'package:flutter/material.dart';
import 'package:assignment_5/models/todo_filter.dart';
import 'package:assignment_5/models/todo_item.dart';
import 'package:assignment_5/widgets/add_todo_sheet.dart';
import 'package:assignment_5/widgets/empty_todo_view.dart';
import 'package:assignment_5/widgets/filter_bar.dart';
import 'package:assignment_5/widgets/todo_stats_card.dart';
import 'package:assignment_5/widgets/todo_tile.dart';

/// Main screen managing the todo state using [StatefulWidget] and [setState].
class TodoListScreen extends StatefulWidget {
  final List<TodoItem>? initialTodos;

  const TodoListScreen({
    super.key,
    this.initialTodos,
  });

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late List<TodoItem> _todos;
  TodoFilter _currentFilter = TodoFilter.all;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Initialize with provided todos or a curated set of academic demo tasks
    _todos = widget.initialTodos ?? _generateInitialTodos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TodoItem> _generateInitialTodos() {
    final now = DateTime.now();
    return [
      TodoItem(
        id: '1',
        title: 'Review Flutter StatefulWidget Lifecycle',
        description: 'Understand createState, initState, setState, and dispose.',
        isCompleted: true,
        createdAt: now.subtract(const Duration(hours: 3)),
        priority: TodoPriority.high,
        category: TodoCategory.study,
      ),
      TodoItem(
        id: '2',
        title: 'Build Assignment 5 Todo List with setState',
        description: 'Implement add, delete, and mark-complete operations.',
        isCompleted: false,
        createdAt: now.subtract(const Duration(hours: 2)),
        priority: TodoPriority.high,
        category: TodoCategory.work,
      ),
      TodoItem(
        id: '3',
        title: 'Prepare Assignment 5 PDF Report',
        description: 'Document challenges, code walkthrough, and test cases.',
        isCompleted: false,
        createdAt: now.subtract(const Duration(hours: 1)),
        priority: TodoPriority.medium,
        category: TodoCategory.study,
      ),
      TodoItem(
        id: '4',
        title: 'Submit Assignment to GitHub Repository',
        description: 'Create branch assignment_5 and push with a detailed README.',
        isCompleted: false,
        createdAt: now,
        priority: TodoPriority.low,
        category: TodoCategory.personal,
      ),
    ];
  }

  // -------------------------------------------------------------
  // STATE MUTATION OPERATIONS VIA setState()
  // -------------------------------------------------------------

  /// Adds a new [TodoItem] to the list and updates UI state via [setState].
  void _addTodo(TodoItem item) {
    setState(() {
      _todos.insert(0, item);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added task "${item.title}"'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Toggles the completion state of a task by ID via [setState].
  void _toggleTodoComplete(String id, bool? isCompleted) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      setState(() {
        final current = _todos[index];
        _todos[index] = current.copyWith(
          isCompleted: isCompleted ?? !current.isCompleted,
        );
      });
    }
  }

  /// Deletes a task by ID with Undo support via [setState].
  void _deleteTodo(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final removed = _todos[index];
    setState(() {
      _todos.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${removed.title}"'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
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

  /// Clears all completed tasks via [setState].
  void _clearCompleted() {
    final completedCount = _todos.where((t) => t.isCompleted).length;
    if (completedCount == 0) return;

    setState(() {
      _todos.removeWhere((t) => t.isCompleted);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cleared $completedCount completed task(s).'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Displays the modal bottom sheet for entering a new task.
  void _showAddTodoSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => AddTodoSheet(
        onAdd: _addTodo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final completedCount = _todos.where((t) => t.isCompleted).length;
    final activeCount = _todos.length - completedCount;

    // Filter by status tab
    List<TodoItem> filtered = _todos.where((todo) {
      switch (_currentFilter) {
        case TodoFilter.all:
          return true;
        case TodoFilter.active:
          return !todo.isCompleted;
        case TodoFilter.completed:
          return todo.isCompleted;
      }
    }).toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) {
        final q = _searchQuery.toLowerCase();
        return t.title.toLowerCase().contains(q) ||
            t.description.toLowerCase().contains(q);
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assignment 5',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'StatefulWidget & setState Todo List',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          if (completedCount > 0)
            IconButton(
              key: const Key('clear_completed_button'),
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: 'Clear Completed Tasks',
              onPressed: _clearCompleted,
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (val) {
              if (val == 'reset') {
                setState(() {
                  _todos = _generateInitialTodos();
                  _searchQuery = '';
                  _searchController.clear();
                });
              } else if (val == 'clear_all') {
                setState(() {
                  _todos.clear();
                });
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.restart_alt_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Reset Demo Tasks'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all_rounded, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Clear All Tasks', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Task Progress Tracker Card
          SliverToBoxAdapter(
            child: TodoStatsCard(
              totalCount: _todos.length,
              completedCount: completedCount,
            ),
          ),

          // Search Input Field
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: TextField(
                key: const Key('todo_search_field'),
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search tasks by title or keyword...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          // Filter Segmented Bar
          SliverToBoxAdapter(
            child: FilterBar(
              selectedFilter: _currentFilter,
              onFilterChanged: (filter) {
                setState(() => _currentFilter = filter);
              },
              allCount: _todos.length,
              activeCount: activeCount,
              completedCount: completedCount,
            ),
          ),

          // Content List or Empty View
          if (filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyTodoView(
                filter: _currentFilter,
                onAddTask: _showAddTodoSheet,
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final todo = filtered[index];
                  return TodoTile(
                    key: ValueKey(todo.id),
                    todo: todo,
                    onToggleComplete: (val) =>
                        _toggleTodoComplete(todo.id, val),
                    onDelete: () => _deleteTodo(todo.id),
                  );
                },
                childCount: filtered.length,
              ),
            ),

          // Bottom padding for FAB space
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('add_task_fab'),
        onPressed: _showAddTodoSheet,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
