enum TaskStatus { todo, inProgress, completed }

class Task {
  final String id;
  final String title;
  final TaskStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final double progress; // 0.0 to 1.0

  Task({
    required this.id,
    required this.title,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.progress,
  });
}
