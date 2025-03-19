import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';
import '../providers/user_provider.dart';
import '../screens/task_screen.dart';
import 'package:intl/intl.dart';
=======
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';
import '../adapters/db.dart';
import 'package:provider/provider.dart';
>>>>>>> 455ab0d336b011cd420e673883058461470b706b

class ProjectScreen extends StatefulWidget {
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
<<<<<<< HEAD
=======
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String _selectedStatus = "Por Hacer";
  String? _selectedUser;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));

>>>>>>> 455ab0d336b011cd420e673883058461470b706b
  @override
  void initState() {
    super.initState();
    Provider.of<ProjectProvider>(context, listen: false).fetchProjects();
  }

<<<<<<< HEAD
  void _createProject() {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController statusController = TextEditingController(text: 'Por Hacer');
    String? selectedUser;
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(Duration(days: 30));

    void _selectDate(BuildContext context, bool isStart) async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: isStart ? startDate : endDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        setState(() {
          if (isStart) {
            startDate = picked;
          } else {
            endDate = picked;
          }
        });
      }
    }

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
                TextField(controller: statusController, decoration: InputDecoration(labelText: 'Estado')),
                FutureBuilder(
                  future: Provider.of<UserProvider>(context, listen: false).getUsers(),
                  builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return DropdownButtonFormField(
                      items: snapshot.data!.map((user) {
                        return DropdownMenuItem(
                          value: user['uid'],
                          child: Text(user['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedUser = value.toString();
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
                        child: Text('Fecha Inicio: ${DateFormat('yyyy-MM-dd').format(startDate)}'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _selectDate(context, false),
                        child: Text('Fecha Fin: ${DateFormat('yyyy-MM-dd').format(endDate)}'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty && selectedUser != null) {
                  ProjectModel newProject = ProjectModel(
                    id: '',
                    name: nameController.text,
                    description: descriptionController.text,
                    status: statusController.text,
                    assignedTo: selectedUser!,
                    startDate: startDate,
                    endDate: endDate,
                  );
                  await Provider.of<ProjectProvider>(context, listen: false).addProject(newProject);
                  Navigator.pop(context);
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
=======
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
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
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
<<<<<<< HEAD
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _createProject(),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await Provider.of<ProjectProvider>(context, listen: false).deleteProject(project.id);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add_task, color: Colors.green),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TaskScreen(projectId: project.id)),
                        ),
                      ),
                    ],
=======
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await Provider.of<ProjectProvider>(context, listen: false).deleteProject(project.id);
                    },
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
<<<<<<< HEAD
        onPressed: _createProject,
=======
        onPressed: () => _showAddProjectDialog(),
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
<<<<<<< HEAD
}
=======

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
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
