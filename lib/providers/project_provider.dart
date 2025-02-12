import 'package:flutter/material.dart';

class ProjectProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _projects = [];

  List<Map<String, dynamic>> get projects => _projects;

  void addProject(String name) {
    _projects.add({'id': DateTime.now().toString(), 'name': name});
    notifyListeners();
  }

  void removeProject(String id) {
    _projects.removeWhere((project) => project['id'] == id);
    notifyListeners();
  }
}