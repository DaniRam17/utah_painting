import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project.dart';

class ProjectProvider with ChangeNotifier {
  List<ProjectModel> _projects = [];
  bool _isLoading = false;

  List<ProjectModel> get projects => _projects;
  bool get isLoading => _isLoading;

  Future<void> fetchProjects() async {
    _isLoading = true;
    notifyListeners();
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('projects').get();
      _projects = snapshot.docs.map((doc) => ProjectModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error obteniendo proyectos: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProject(ProjectModel project) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance.collection('projects').add(project.toFirestore());
      project.id = docRef.id;
      _projects.add(project);
      notifyListeners();
    } catch (e) {
      print('Error agregando proyecto: $e');
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await FirebaseFirestore.instance.collection('projects').doc(projectId).delete();
      _projects.removeWhere((project) => project.id == projectId);
      notifyListeners();
    } catch (e) {
      print('Error eliminando proyecto: $e');
    }
  }
}
