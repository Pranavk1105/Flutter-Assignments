/// Represents the active display filter for the todo list.
enum TodoFilter {
  all('All'),
  active('Pending'),
  completed('Completed');

  final String label;
  const TodoFilter(this.label);
}
