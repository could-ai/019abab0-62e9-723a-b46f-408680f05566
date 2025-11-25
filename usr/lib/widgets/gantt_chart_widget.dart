import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

class GanttChartWidget extends StatelessWidget {
  final List<Task> tasks;

  const GanttChartWidget({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    // Determine timeline range
    DateTime minDate = DateTime.now().subtract(const Duration(days: 2));
    DateTime maxDate = DateTime.now().add(const Duration(days: 10));
    int totalDays = maxDate.difference(minDate).inDays + 1;
    double dayWidth = 50.0;

    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Dates Header
          SizedBox(
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Row(
                children: List.generate(totalDays, (index) {
                  final date = minDate.add(Duration(days: index));
                  return Container(
                    width: dayWidth,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.white.withOpacity(0.05)),
                        bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('d').format(date),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          DateFormat('E').format(date).substring(0, 1),
                          style: TextStyle(color: Colors.grey[500], fontSize: 10),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          
          // Timeline Bars
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: SizedBox(
                  width: totalDays * dayWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: tasks.map((task) {
                      // Calculate position and width
                      int startOffset = task.startDate.difference(minDate).inDays;
                      int duration = task.endDate.difference(task.startDate).inDays + 1;
                      
                      // Clamp values to ensure they render within bounds if dates are weird
                      if (startOffset < 0) {
                        duration += startOffset;
                        startOffset = 0;
                      }
                      
                      return Container(
                        height: 40,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Stack(
                          children: [
                            // Grid lines background
                            Row(
                              children: List.generate(totalDays, (index) {
                                return Container(
                                  width: dayWidth,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(color: Colors.white.withOpacity(0.05)),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            // Task Bar
                            Positioned(
                              left: startOffset * dayWidth,
                              width: (duration * dayWidth).toDouble(),
                              top: 8,
                              bottom: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(task.status),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getStatusColor(task.status).withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  task.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed: return Colors.greenAccent;
      case TaskStatus.inProgress: return Colors.blueAccent;
      case TaskStatus.todo: return Colors.orangeAccent;
    }
  }
}
