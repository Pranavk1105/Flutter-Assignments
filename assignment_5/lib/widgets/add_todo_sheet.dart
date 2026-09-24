import 'package:flutter/material.dart';
import 'package:assignment_5/models/todo_item.dart';

/// Modal bottom sheet form allowing users to enter details for a new task.
class AddTodoSheet extends StatefulWidget {
  final ValueChanged<TodoItem> onAdd;

  const AddTodoSheet({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends State<AddTodoSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  TodoPriority _selectedPriority = TodoPriority.medium;
  TodoCategory _selectedCategory = TodoCategory.general;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final newTodo = TodoItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        createdAt: DateTime.now(),
        priority: _selectedPriority,
        category: _selectedCategory,
      );

      widget.onAdd(newTodo);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: bottomInset + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add New Task',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Title Field
              TextFormField(
                key: const Key('add_todo_title_field'),
                controller: _titleController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Task Title *',
                  hintText: 'e.g. Complete Flutter Assignment 5',
                  prefixIcon: const Icon(Icons.title_rounded, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  if (val.trim().length < 2) {
                    return 'Title must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Description Field
              TextFormField(
                key: const Key('add_todo_desc_field'),
                controller: _descController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Add additional details or subtasks...',
                  prefixIcon: const Icon(Icons.notes_rounded, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Priority Selector
              const Text(
                'Priority Level',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: TodoPriority.values.map((priority) {
                  final isSelected = _selectedPriority == priority;
                  return ChoiceChip(
                    key: Key('priority_chip_${priority.name}'),
                    label: Text(priority.label),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedPriority = priority);
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Category Selector
              const Text(
                'Category',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: TodoCategory.values.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    key: Key('category_chip_${cat.name}'),
                    label: Text(cat.label),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = cat);
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  key: const Key('submit_new_todo_button'),
                  onPressed: _submit,
                  icon: const Icon(Icons.add_task_rounded),
                  label: const Text(
                    'Add Task',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
