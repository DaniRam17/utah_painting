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
      print('Error obteniendo tareas: $e');
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
      print('Error agregando tarea: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      print('Error eliminando tarea: $e');
    }
  }
}
