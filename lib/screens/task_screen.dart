import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';
import '../adapters/local_storage.dart';
import '../adapters/db.dart';

class TaskScreen extends StatefulWidget {
  final String projectId;

  TaskScreen({required this.projectId});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<TaskModel> _tasks = [];
  bool _isLoading = true;

  final TextEditingController nameController = TextEditingController();
  String _selectedPriority = "Media";
  String? _selectedUser;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    List<TaskModel>? cachedTasks = LocalStorage.getTasks();
    if (cachedTasks != null && cachedTasks.isNotEmpty) {
      setState(() {
        _tasks = cachedTasks.where((task) => task.projectId == widget.projectId).toList();
        _isLoading = false;
      });
    }
    List<TaskModel> tasks = await DatabaseService().getTasks();
    if (tasks.isNotEmpty) {
      LocalStorage.setTasks(tasks);
      setState(() {
        _tasks = tasks.where((task) => task.projectId == widget.projectId).toList();
        _isLoading = false;
      });
    }
  }

  void _addTask() async {
    if (nameController.text.isNotEmpty && _selectedUser != null) {
      TaskModel newTask = TaskModel(
        id: '',
        projectId: widget.projectId,
        name: nameController.text,
        assignedTo: _selectedUser!,
        priority: _selectedPriority,
        startDate: _startDate,
        endDate: _endDate,
        status: 'Por hacer',
        comments: '',
      );
      await DatabaseService().createTask(newTask);
      _loadTasks();
      nameController.clear();
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
      appBar: AppBar(title: Text('Tareas')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                var task = _tasks[index];
                return Card(
                  child: ListTile(
                    title: Text(task.name),
                    subtitle: Text('Prioridad: ${task.priority} - Estado: ${task.status}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await DatabaseService().deleteTask(task.id);
                        _loadTasks();
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nueva Tarea'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nombre')),
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
            ElevatedButton(onPressed: _addTask, child: Text('Guardar')),
          ],
        );
      },
    );
  }
}
