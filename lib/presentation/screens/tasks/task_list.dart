import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utah_painting/providers/task_provider.dart';
import 'package:utah_painting/presentation/screens/tasks/task_create.dart';

class TaskListScreen extends StatelessWidget {
  final String projectId;
  const TaskListScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasksByProject[projectId] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Task List')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task['name']!),
            subtitle: Text('Assigned to: ${task['assignedTo']}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => taskProvider.removeTask(projectId, task['name']!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskCreateScreen(projectId: projectId)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}