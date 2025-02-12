import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  Map<String, List<Map<String, String>>> _tasksByProject = {};

  Map<String, List<Map<String, String>>> get tasksByProject => _tasksByProject;

  void addTask(String projectId, String name, String assignedTo) {
    if (!_tasksByProject.containsKey(projectId)) {
      _tasksByProject[projectId] = [];
    }
    _tasksByProject[projectId]!.add({'name': name, 'assignedTo': assignedTo});
    notifyListeners();
  }

  void removeTask(String projectId, String name) {
    _tasksByProject[projectId]?.removeWhere((task) => task['name'] == name);
    notifyListeners();
  }
}