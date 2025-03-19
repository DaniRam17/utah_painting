<<<<<<< HEAD
// task_provider.dart - Agregar updateTask
=======
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];
  bool _isLoading = false;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> fetchTasks(String projectId) async {
    _isLoading = true;
    notifyListeners();
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('projectId', isEqualTo: projectId)
          .get();
      _tasks = snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    } catch (e) {
<<<<<<< HEAD
      print('Error obteniendo tareas: \$e');
=======
      print('Error obteniendo tareas: $e');
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance.collection('tasks').add(task.toFirestore());
      task.id = docRef.id;
      _tasks.add(task);
      notifyListeners();
    } catch (e) {
<<<<<<< HEAD
      print('Error agregando tarea: \$e');
    }
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update(data);
      int index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = TaskModel.fromFirestore(await FirebaseFirestore.instance.collection('tasks').doc(taskId).get());
        notifyListeners();
      }
    } catch (e) {
      print('Error actualizando tarea: \$e');
=======
      print('Error agregando tarea: $e');
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
<<<<<<< HEAD
      print('Error eliminando tarea: \$e');
=======
      print('Error eliminando tarea: $e');
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
    }
  }
}
