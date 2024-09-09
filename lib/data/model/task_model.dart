enum TaskPriority { low, medium, high, immediate }

class TaskModel {
  int? id;
  String title;
  String description;
  TaskPriority priority;
  DateTime dueDate;
  DateTime? reminder;
  bool isCompleted;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    this.reminder,
    this.isCompleted = false,
  });

  // Conversion to/from Map for storage
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],  // Add id for primary key
      title: json['title'],
      description: json['description'],
      priority: TaskPriority.values[json['priority']],  // Convert int back to enum
      dueDate: DateTime.parse(json['dueDate']),
      reminder: json['reminder'] != null ? DateTime.parse(json['reminder']) : null,
      isCompleted: json['isCompleted'] == 1,  // Convert int to bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,  // Include id in map
      'title': title,
      'description': description,
      'priority': priority.index,  // Store enum as integer
      'dueDate': dueDate.toIso8601String(),
      'reminder': reminder?.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,  // Convert bool to int
    };
  }
}
