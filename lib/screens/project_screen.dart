import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';
import '../adapters/db.dart';
import 'package:provider/provider.dart';

class ProjectScreen extends StatefulWidget {
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String _selectedStatus = "Por Hacer";
  String? _selectedUser;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));

  @override
  void initState() {
    super.initState();
    Provider.of<ProjectProvider>(context, listen: false).fetchProjects();
  }

  void _addProject() async {
    if (nameController.text.isNotEmpty && descriptionController.text.isNotEmpty && _selectedUser != null) {
      ProjectModel newProject = ProjectModel(
        id: '',
        name: nameController.text,
        description: descriptionController.text,
        status: _selectedStatus,
        assignedTo: _selectedUser!,
        startDate: _startDate,
        endDate: _endDate,
      );
      await Provider.of<ProjectProvider>(context, listen: false).addProject(newProject);
      nameController.clear();
      descriptionController.clear();
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Proyectos')),
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          if (projectProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: projectProvider.projects.length,
            itemBuilder: (context, index) {
              var project = projectProvider.projects[index];
              return Card(
                child: ListTile(
                  title: Text(project.name),
                  subtitle: Text('Estado: ${project.status}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await Provider.of<ProjectProvider>(context, listen: false).deleteProject(project.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProjectDialog(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  void _showAddProjectDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nuevo Proyecto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nombre')),
                TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Descripción')),
                DropdownButtonFormField(
                  value: _selectedStatus,
                  items: ['Por Hacer', 'En progreso', 'Completado'].map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value.toString();
                    });
                  },
                  decoration: InputDecoration(labelText: 'Estado'),
                ),
                FutureBuilder(
                  future: DatabaseService().getUsers(),
                  builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    var users = snapshot.data!;
                    return DropdownButtonFormField(
                      value: _selectedUser,
                      items: users.map((user) {
                        return DropdownMenuItem(
                          value: user['uid'],
                          child: Text(user['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedUser = value.toString();
                        });
                      },
                      decoration: InputDecoration(labelText: 'Asignado a'),
                    );
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _selectDate(context, true),
                        child: Text('Fecha Inicio: ${_startDate.toLocal()}'.split(' ')[0]),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _selectDate(context, false),
                        child: Text('Fecha Fin: ${_endDate.toLocal()}'.split(' ')[0]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
            ElevatedButton(onPressed: _addProject, child: Text('Guardar')),
          ],
        );
      },
    );
  }
}
