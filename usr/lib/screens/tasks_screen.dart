import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
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
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _buildTaskCard(context, task, isMobile);
            },
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task, bool isMobile) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 12 : 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => TaskService().advanceTaskStatus(task),
                  borderRadius: BorderRadius.circular(30),
                  child: CircleAvatar(
                    radius: isMobile ? 18 : 20,
                    backgroundColor: _getStatusColor(task.status).withOpacity(0.2),
                    child: Icon(
                      _getStatusIcon(task.status),
                      color: _getStatusColor(task.status),
                      size: isMobile ? 18 : 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 14 : 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (task.description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            task.description,
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: isMobile ? 11 : 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      Text(
                        "${DateFormat('MMM d').format(task.startDate)} - ${DateFormat('MMM d').format(task.endDate)}",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: isMobile ? 11 : 12,
                        ),
                      ),
                      if (task.status != TaskStatus.completed)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "Tap icon to mark as ${_getNextStatusText(task.status)}",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditTaskDialog(context, task);
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context, task);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.redAccent),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.redAccent)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: task.progress,
                    backgroundColor: Colors.grey[800],
                    color: _getStatusColor(task.status),
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "${(task.progress * 100).toInt()}%",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 11 : 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    DateTime startDate = task.startDate;
    DateTime endDate = task.endDate;
    TaskStatus status = task.status;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text("Edit Task"),
          content: SingleChildScrollView(
            child: SizedBox(
              width: isMobile ? MediaQuery.of(context).size.width * 0.9 : 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Task Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setDialogState(() => startDate = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Start Date",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(DateFormat('MMM d, y').format(startDate)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: endDate,
                        firstDate: startDate,
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setDialogState(() => endDate = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "End Date",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(DateFormat('MMM d, y').format(endDate)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TaskStatus>(
                    value: status,
                    decoration: const InputDecoration(
                      labelText: "Status",
                      border: OutlineInputBorder(),
                    ),
                    items: TaskStatus.values.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text(Task(
                          id: '',
                          title: '',
                          status: s,
                          startDate: DateTime.now(),
                          endDate: DateTime.now(),
                          progress: 0,
                        ).statusLabel),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => status = val);
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  TaskService().updateTask(Task(
                    id: task.id,
                    title: titleController.text,
                    description: descriptionController.text,
                    status: status,
                    startDate: startDate,
                    endDate: endDate,
                    progress: status == TaskStatus.completed ? 1.0 : (status == TaskStatus.inProgress ? 0.5 : 0.0),
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("Delete Task"),
        content: Text("Are you sure you want to delete '${task.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              TaskService().deleteTask(task.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  String _getNextStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo: return "IN PROGRESS";
      case TaskStatus.inProgress: return "COMPLETED";
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