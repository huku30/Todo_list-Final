import 'package:flutter/material.dart';

class ActiveTasksTab extends StatelessWidget {
  final List<Map<String, dynamic>> activeTasks;
  final Function(int, int) onToggleTask;
  final Function(int) onDeleteTask;
  final Function(int, String) onEditTask;

  const ActiveTasksTab({
    super.key,
    required this.activeTasks,
    required this.onToggleTask,
    required this.onDeleteTask,
    required this.onEditTask,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return activeTasks.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  "No active tasks",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Add a new task to get started",
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
            itemCount: activeTasks.length,
            itemBuilder: (_, index) {
              final task = activeTasks[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.white,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: Checkbox(
                    value: false,
                    onChanged: (_) =>
                        onToggleTask(task['id'], task['isDone']),
                    activeColor: const Color(0xFF6366F1),
                  ),
                  title: Text(
                    task['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
