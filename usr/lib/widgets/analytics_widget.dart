import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/task_model.dart';

class AnalyticsWidget extends StatelessWidget {
  final List<Task> tasks;

  const AnalyticsWidget({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final completed = tasks.where((t) => t.status == TaskStatus.completed).length;
    final inProgress = tasks.where((t) => t.status == TaskStatus.inProgress).length;
    final todo = tasks.where((t) => t.status == TaskStatus.todo).length;
    final total = tasks.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Pie Chart
          SizedBox(
            height: 120,
            width: 120,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 30,
                sections: [
                  PieChartSectionData(
                    color: Colors.greenAccent,
                    value: completed.toDouble(),
                    title: '',
                    radius: 15,
                  ),
                  PieChartSectionData(
                    color: Colors.blueAccent,
                    value: inProgress.toDouble(),
                    title: '',
                    radius: 15,
                  ),
                  PieChartSectionData(
                    color: Colors.orangeAccent,
                    value: todo.toDouble(),
                    title: '',
                    radius: 15,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatRow("Completed", completed, total, Colors.greenAccent),
                const SizedBox(height: 10),
                _buildStatRow("In Progress", inProgress, total, Colors.blueAccent),
                const SizedBox(height: 10),
                _buildStatRow("To Do", todo, total, Colors.orangeAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int count, int total, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const Spacer(),
        Text(
          "$count",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
