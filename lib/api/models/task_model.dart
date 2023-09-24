class TasksType {
  final String title;
  final String description;
  final String dueDate;
  final int userId;
  final int status;

  TasksType({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.userId,
    required this.status,
  });

  factory TasksType.fromJson(Map<String, dynamic> json) {
    return TasksType(
      title: json['title'],
      description: json['description'],
      dueDate: json['due_date'],
      userId: json['user_id'],
      status: json['status'],
    );
  }
}
