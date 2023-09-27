class TasksType {
  final int? id;
  final String title;
  final String description;
  final String dueDate;
  final String? userId;
  final int status;

  TasksType({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.userId,
    required this.status,
  });

  factory TasksType.fromJson(Map<String, dynamic> json) {
    return TasksType(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: json['due_date'],
      userId: json['user_id'],
      status: json['status'],
    );
  }
}
