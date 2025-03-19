import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/project_provider.dart';
import '../providers/user_provider.dart';
import 'package:intl/intl.dart';

class TaskScreen extends StatefulWidget {
  final String projectId;

  TaskScreen({required this.projectId});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).fetchTasks(widget.projectId);
  }

  void _createOrEditTask({TaskModel? task}) {
    TextEditingController nameController = TextEditingController(text: task?.name ?? '');
    TextEditingController statusController = TextEditingController(text: task?.status ?? 'Por Hacer');
    TextEditingController commentsController = TextEditingController(text: task?.comments ?? '');
    String? selectedProject = task?.projectId ?? widget.projectId;
    String? selectedUser = task?.assignedTo;
    String selectedPriority = task?.priority ?? "Media";
    DateTime startDate = task?.startDate ?? DateTime.now();
    DateTime endDate = task?.endDate ?? DateTime.now().add(Duration(days: 7));

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
          title: Text(task == null ? 'Nueva Tarea' : 'Editar Tarea'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nombre')),
                FutureBuilder(
                  future: Provider.of<ProjectProvider>(context, listen: false).fetchProjects(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return DropdownButtonFormField(
                      value: selectedProject,
                      items: snapshot.data!.map<DropdownMenuItem<String>>((project) {
                        return DropdownMenuItem(
                          value: project.id,
                          child: Text(project.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedProject = value.toString();
                      },
                      decoration: InputDecoration(labelText: 'Proyecto'),
                    );
                  },
                ),
                FutureBuilder(
                  future: Provider.of<UserProvider>(context, listen: false).getUsers(),
                  builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return DropdownButtonFormField(
                      value: selectedUser,
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
                DropdownButtonFormField(
                  value: selectedPriority,
                  items: ['Alta', 'Media', 'Baja'].map((priority) {
                    return DropdownMenuItem(value: priority, child: Text(priority));
                  }).toList(),
                  onChanged: (value) {
                    selectedPriority = value.toString();
                  },
                  decoration: InputDecoration(labelText: 'Prioridad'),
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
                TextField(controller: statusController, decoration: InputDecoration(labelText: 'Estado')),
                TextField(controller: commentsController, decoration: InputDecoration(labelText: 'Comentarios')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty && selectedProject != null && selectedUser != null) {
                  TaskModel newTask = TaskModel(
                    id: task?.id ?? '',
                    projectId: selectedProject!,
                    name: nameController.text,
                    assignedTo: selectedUser!,
                    priority: selectedPriority,
                    startDate: startDate,
                    endDate: endDate,
                    status: statusController.text,
                    comments: commentsController.text,
                  );
                  if (task == null) {
                    await Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
                  } else {
                    await Provider.of<TaskProvider>(context, listen: false).updateTask(task.id, newTask.toFirestore());
                  }
                  Navigator.pop(context);
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tareas')),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              var task = taskProvider.tasks[index];
              return Card(
                child: ListTile(
                  title: Text(task.name),
                  subtitle: Text('Estado: ${task.status} - Prioridad: ${task.priority}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _createOrEditTask(task: task),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await Provider.of<TaskProvider>(context, listen: false).deleteTask(task.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrEditTask(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}