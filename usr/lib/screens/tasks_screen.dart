import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Tasks"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: TaskService(),
        builder: (context, child) {
          final tasks = TaskService().tasks;
          if (tasks.isEmpty) {
            return const Center(child: Text("No tasks found"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _buildTaskCard(context, task);
            },
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: InkWell(
          onTap: () => TaskService().advanceTaskStatus(task),
          borderRadius: BorderRadius.circular(30),
          child: CircleAvatar(
            backgroundColor: _getStatusColor(task.status).withOpacity(0.2),
            child: Icon(
              _getStatusIcon(task.status),
              color: _getStatusColor(task.status),
              size: 20,
            ),
          ),
        ),
        title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "${DateFormat('MMM d').format(task.startDate)} - ${DateFormat('MMM d').format(task.endDate)}",
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            if (task.status != TaskStatus.completed)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "Tap icon to mark as ${_getNextStatusText(task.status)}",
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 10),
                ),
              ),
          ],
        ),
        trailing: SizedBox(
          width: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${(task.progress * 100).toInt()}%",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: task.progress,
                backgroundColor: Colors.grey[800],
                color: _getStatusColor(task.status),
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getNextStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo: return "In Progress";
      case TaskStatus.inProgress: return "Completed";
      case TaskStatus.completed: return "Done";
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed: return Colors.greenAccent;
      case TaskStatus.inProgress: return Colors.blueAccent;
      case TaskStatus.todo: return Colors.orangeAccent;
    }
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed: return Icons.check;
      case TaskStatus.inProgress: return Icons.timelapse;
      case TaskStatus.todo: return Icons.circle_outlined;
    }
  }
}
