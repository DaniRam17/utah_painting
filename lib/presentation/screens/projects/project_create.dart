import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utah_painting/providers/project_provider.dart';

class ProjectCreateScreen extends StatelessWidget {
  const ProjectCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Project')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Project Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  Provider.of<ProjectProvider>(context, listen: false).addProject(nameController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Create Project'),
            ),
          ],
        ),
      ),
    );
  }
}
