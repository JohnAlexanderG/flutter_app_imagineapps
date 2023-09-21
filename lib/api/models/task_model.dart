class TasksType {
  final int id;
  final String title;
  final String description;
  final String dueDate;
  final int userId;
  final int status;

  TasksType({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.userId,
    required this.status,
  });
}
