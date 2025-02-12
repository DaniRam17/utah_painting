import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utah_painting/providers/task_provider.dart';

class TaskCreateScreen extends StatelessWidget {
  final String projectId;
  const TaskCreateScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController assignedController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Task Name')),
            TextField(controller: assignedController, decoration: const InputDecoration(labelText: 'Assigned To')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<TaskProvider>(context, listen: false)
                    .addTask(projectId, nameController.text, assignedController.text);
                Navigator.pop(context);
              },
              child: const Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}