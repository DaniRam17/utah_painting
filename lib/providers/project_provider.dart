<<<<<<< HEAD

// project_provider.dart - Agregar updateProject
=======
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
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
<<<<<<< HEAD
      print('Error obteniendo proyectos: \$e');
=======
      print('Error obteniendo proyectos: $e');
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
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
<<<<<<< HEAD
      print('Error agregando proyecto: \$e');
    }
  }

  Future<void> updateProject(String projectId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection('projects').doc(projectId).update(data);
      int index = _projects.indexWhere((project) => project.id == projectId);
      if (index != -1) {
        _projects[index] = ProjectModel.fromFirestore(await FirebaseFirestore.instance.collection('projects').doc(projectId).get());
        notifyListeners();
      }
    } catch (e) {
      print('Error actualizando proyecto: \$e');
=======
      print('Error agregando proyecto: $e');
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await FirebaseFirestore.instance.collection('projects').doc(projectId).delete();
      _projects.removeWhere((project) => project.id == projectId);
      notifyListeners();
    } catch (e) {
<<<<<<< HEAD
      print('Error eliminando proyecto: \$e');
=======
      print('Error eliminando proyecto: $e');
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
    }
  }
}
