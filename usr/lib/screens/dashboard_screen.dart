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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
