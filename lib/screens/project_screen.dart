import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectScreen extends StatefulWidget {
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void _addProject() async {
    if (nameController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
      await _db.collection('projects').add({
        'name': nameController.text,
        'description': descriptionController.text,
        'status': 'Por Hacer',
        'startDate': Timestamp.now(),
        'endDate': Timestamp.now(),
        'assignedTo': '',
      });
      nameController.clear();
      descriptionController.clear();
      Navigator.pop(context);
    }
  }

  void _deleteProject(String projectId) async {
    await _db.collection('projects').doc(projectId).delete();
  }

  void _showAddProjectDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nuevo Proyecto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nombre')),
              TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Descripción')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
            ElevatedButton(onPressed: _addProject, child: Text('Guardar')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Proyectos'), backgroundColor: Colors.blueAccent),
      body: StreamBuilder(
        stream: _db.collection('projects').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var projects = snapshot.data!.docs;
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              var project = projects[index];
              return Card(
                color: Colors.blueGrey[900],
                child: ListTile(
                  title: Text(project['name'], style: TextStyle(color: Colors.white)),
                  subtitle: Text('Estado: ${project['status']}', style: TextStyle(color: Colors.white70)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteProject(project.id),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProjectDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
