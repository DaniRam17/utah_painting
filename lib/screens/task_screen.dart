import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskScreen extends StatefulWidget {
  final String projectId;
  TaskScreen({required this.projectId});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController assignedToController = TextEditingController();
  String _selectedPriority = 'Media';

  void _addTask() async {
    if (nameController.text.isNotEmpty && assignedToController.text.isNotEmpty) {
      await _db.collection('tasks').add({
        'projectId': widget.projectId,
        'name': nameController.text,
        'assignedTo': assignedToController.text,
        'priority': _selectedPriority,
        'startDate': Timestamp.now(),
        'endDate': Timestamp.now(),
        'status': 'Por hacer',
        'comments': '',
      });
      nameController.clear();
      assignedToController.clear();
      Navigator.pop(context);
    }
  }

  void _deleteTask(String taskId) async {
    await _db.collection('tasks').doc(taskId).delete();
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nueva Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nombre')),
              TextField(controller: assignedToController, decoration: InputDecoration(labelText: 'Asignado a')),
              DropdownButtonFormField(
                value: _selectedPriority,
                items: ['Alta', 'Media', 'Baja'].map((priority) {
                  return DropdownMenuItem(value: priority, child: Text(priority));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value.toString();
                  });
                },
                decoration: InputDecoration(labelText: 'Prioridad'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
            ElevatedButton(onPressed: _addTask, child: Text('Guardar')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tareas'), backgroundColor: Colors.blueAccent),
      body: StreamBuilder(
        stream: _db.collection('tasks').where('projectId', isEqualTo: widget.projectId).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var tasks = snapshot.data!.docs;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              var task = tasks[index];
              return Card(
                color: Colors.blueGrey[900],
                child: ListTile(
                  title: Text(task['name'], style: TextStyle(color: Colors.white)),
                  subtitle: Text('Prioridad: ${task['priority']}', style: TextStyle(color: Colors.white70)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTask(task.id),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}