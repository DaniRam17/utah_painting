import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utah_painting/providers/project_provider.dart';
import 'package:utah_painting/presentation/screens/projects/project_create.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: ListView.builder(
        itemCount: projectProvider.projects.length,
        itemBuilder: (context, index) {
          final project = projectProvider.projects[index];
          return ListTile(
            title: Text(project['name']!),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => projectProvider.removeProject(project['id']!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProjectCreateScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}