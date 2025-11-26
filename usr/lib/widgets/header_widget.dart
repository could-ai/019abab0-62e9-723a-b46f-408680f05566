import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../services/task_service.dart';
import '../models/task_model.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  late DateTime _currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _showNotifications() {
    final nearingTasks = TaskService().getTasksNearingDeadline();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            const Icon(Icons.notifications, color: Colors.white),
            const SizedBox(width: 10),
            const Text("Reminders"),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: nearingTasks.isEmpty 
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No upcoming deadlines."),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: nearingTasks.length,
                itemBuilder: (context, index) {
                  final task = nearingTasks[index];
                  final daysLeft = task.endDate.difference(DateTime.now()).inDays;
                  final hoursLeft = task.endDate.difference(DateTime.now()).inHours;
                  
                  String timeLeftStr;
                  if (daysLeft > 0) {
                    timeLeftStr = "$daysLeft days left";
                  } else if (hoursLeft > 0) {
                    timeLeftStr = "$hoursLeft hours left";
                  } else {
                    timeLeftStr = "Due soon";
                  }

                  return ListTile(
                    leading: const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
                    title: Text(task.title),
                    subtitle: Text(
                      "Deadline: ${DateFormat('MMM d').format(task.endDate)} ($timeLeftStr)",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                },
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: TaskService(),
      builder: (context, child) {
        final notificationCount = TaskService().getTasksNearingDeadline().length;
        
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE, d MMMM').format(_currentTime),
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Hello, User",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Notification Bell
                    Stack(
                      children: [
                        IconButton(
                          onPressed: _showNotifications,
                          icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
                        ),
                        if (notificationCount > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '$notificationCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    // Time Display
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Text(
                        DateFormat('h:mm a').format(_currentTime),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      }
    );
  }
}
