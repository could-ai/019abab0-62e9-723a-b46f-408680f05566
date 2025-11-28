import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskService extends ChangeNotifier {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'UI Design',
      description: 'Design the user interface mockups and prototypes',
      status: TaskStatus.completed,
      startDate: DateTime.now().subtract(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 1)),
      progress: 1.0,
    ),
    Task(
      id: '2',
      title: 'Backend API',
      description: 'Develop RESTful API endpoints',
      status: TaskStatus.inProgress,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 4)),
      progress: 0.4,
    ),
    Task(
      id: '3',
      title: 'Database Setup',
      description: 'Configure database schema and migrations',
      status: TaskStatus.inProgress,
      startDate: DateTime.now().add(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 3)),
      progress: 0.7,
    ),
    Task(
      id: '4',
      title: 'Testing',
      description: 'Write unit and integration tests',
      status: TaskStatus.todo,
      startDate: DateTime.now().add(const Duration(days: 4)),
      endDate: DateTime.now().add(const Duration(days: 7)),
      progress: 0.0,
    ),
    Task(
      id: '5',
      title: 'Deployment',
      description: 'Deploy to production environment',
      status: TaskStatus.todo,
      startDate: DateTime.now().add(const Duration(days: 6)),
      endDate: DateTime.now().add(const Duration(days: 8)),
      progress: 0.0,
    ),
    Task(
      id: '6',
      title: 'Client Presentation',
      description: 'Present project progress to stakeholders',
      status: TaskStatus.todo,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(hours: 24)),
      progress: 0.0,
    ),
  ];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    int index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  void advanceTaskStatus(Task task) {
    int index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      Task currentTask = _tasks[index];
      TaskStatus newStatus = currentTask.status;
      double newProgress = currentTask.progress;

      if (currentTask.status == TaskStatus.todo) {
        newStatus = TaskStatus.inProgress;
        newProgress = 0.5;
      } else if (currentTask.status == TaskStatus.inProgress) {
        newStatus = TaskStatus.completed;
        newProgress = 1.0;
      }

      _tasks[index] = Task(
        id: currentTask.id,
        title: currentTask.title,
        description: currentTask.description,
        status: newStatus,
        startDate: currentTask.startDate,
        endDate: currentTask.endDate,
        progress: newProgress,
      );
      notifyListeners();
    }
  }

  List<Task> getTasksNearingDeadline() {
    final now = DateTime.now();
    return _tasks.where((task) {
      if (task.status == TaskStatus.completed) return false;
      final difference = task.endDate.difference(now);
      return difference.inDays <= 2 && difference.inDays >= 0;
    }).toList();
  }
}