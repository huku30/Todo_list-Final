import 'package:flutter/material.dart';
import 'db_helper.dart';

class EditTaskDialog {
  static Future<void> show(
    BuildContext context, {
    required int taskId,
    required String taskTitle,
    required Function() onTaskUpdated,
  }) {
    final editController = TextEditingController(text: taskTitle);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Task"),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(
            hintText: "Update your task",
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              if (editController.text.isNotEmpty &&
                  editController.text != taskTitle) {
                await DBHelper().updateTaskTitle(taskId, editController.text);
                onTaskUpdated();
                if (context.mounted) {
                  Navigator.pop(context);
                }
              } else if (editController.text.isEmpty) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Task title cannot be empty")),
                  );
                }
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
