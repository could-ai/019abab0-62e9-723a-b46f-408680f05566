import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../widgets/header_widget.dart';
import '../widgets/analytics_widget.dart';
import '../widgets/gantt_chart_widget.dart';
import '../models/task_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Mock Data
  final List<Task> tasks = [
    Task(
      id: '1',
      title: 'UI Design',
      status: TaskStatus.completed,
      startDate: DateTime.now().subtract(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 1)),
      progress: 1.0,
    ),
    Task(
      id: '2',
      title: 'Backend API',
      status: TaskStatus.inProgress,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 4)),
      progress: 0.4,
    ),
    Task(
      id: '3',
      title: 'Database Setup',
      status: TaskStatus.inProgress,
      startDate: DateTime.now().add(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 3)),
      progress: 0.7,
    ),
    Task(
      id: '4',
      title: 'Testing',
      status: TaskStatus.todo,
      startDate: DateTime.now().add(const Duration(days: 4)),
      endDate: DateTime.now().add(const Duration(days: 7)),
      progress: 0.0,
    ),
    Task(
      id: '5',
      title: 'Deployment',
      status: TaskStatus.todo,
      startDate: DateTime.now().add(const Duration(days: 6)),
      endDate: DateTime.now().add(const Duration(days: 8)),
      progress: 0.0,
    ),
  ];

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(const Duration(days: 1));
    TaskStatus status = TaskStatus.todo;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text("Add New Task"),
          content: SingleChildScrollView(
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
                ListTile(
                  title: const Text("Start Date"),
                  subtitle: Text(DateFormat('MMM d, y').format(startDate)),
                  trailing: const Icon(Icons.calendar_today),
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
                ),
                ListTile(
                  title: const Text("End Date"),
                  subtitle: Text(DateFormat('MMM d, y').format(endDate)),
                  trailing: const Icon(Icons.calendar_today),
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
                      child: Text(s.toString().split('.').last.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => status = val);
                  },
                ),
              ],
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
                  _addTask(Task(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    status: status,
                    startDate: startDate,
                    endDate: endDate,
                    progress: status == TaskStatus.completed ? 1.0 : (status == TaskStatus.inProgress ? 0.5 : 0.0),
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text("Add Task"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Time and Calendar
                  const HeaderWidget(),
                  const SizedBox(height: 30),

                  // Analytics Section
                  const Text(
                    "Project Analytics",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  AnalyticsWidget(tasks: tasks),
                  const SizedBox(height: 30),

                  // Gantt Chart Section
                  const Text(
                    "Timeline (Gantt Chart)",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  GanttChartWidget(tasks: tasks),
                  
                  const SizedBox(height: 30),
                  
                  // Recent Tasks List
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Recent Tasks",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {}, 
                        child: const Text("View All")
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildTaskList(),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(task.status).withOpacity(0.2),
              child: Icon(
                _getStatusIcon(task.status),
                color: _getStatusColor(task.status),
                size: 20,
              ),
            ),
            title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(
              "${DateFormat('MMM d').format(task.startDate)} - ${DateFormat('MMM d').format(task.endDate)}",
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
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
      },
    );
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
