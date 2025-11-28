enum TaskStatus { todo, inProgress, completed }

class Task {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final double progress; // 0.0 to 1.0

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.progress,
  });

  String get statusLabel {
    switch (status) {
      case TaskStatus.todo:
        return 'TO DO';
      case TaskStatus.inProgress:
        return 'IN PROGRESS';
      case TaskStatus.completed:
        return 'COMPLETED';
    }
  }
}