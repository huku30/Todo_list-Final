import 'package:flutter/material.dart';

class CompletedTasksTab extends StatelessWidget {
  final List<Map<String, dynamic>> completedTasks;
  final Function(int, int) onToggleTask;
  final Function(int) onDeleteTask;
  final Function(int, String) onEditTask;

  const CompletedTasksTab({
    super.key,
    required this.completedTasks,
    required this.onToggleTask,
    required this.onDeleteTask,
    required this.onEditTask,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return completedTasks.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.done_all,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  "No completed tasks",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Complete a task to see it here",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: completedTasks.length,
            itemBuilder: (_, index) {
              final task = completedTasks[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.green.shade200,
                  ),
                ),
                color: Colors.green.shade50,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: Checkbox(
                    value: true,
                    onChanged: (_) =>
                        onToggleTask(task['id'], task['isDone']),
                    activeColor: Colors.green.shade600,
                  ),
                  title: Text(
                    task['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.blue.shade400,
                        onPressed: () =>
                            onEditTask(task['id'], task['title']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red.shade400,
                        onPressed: () => onDeleteTask(task['id']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
