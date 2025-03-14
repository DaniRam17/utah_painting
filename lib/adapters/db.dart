import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../models/user.dart';

class Db {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db.collection('users').where('uid', isEqualTo: uid).get();
      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData = querySnapshot.docs.first.data();
        return userData;
      }
      return null;
    } catch (e) {
      print('Error occurred calling Firebase!: $e');
      return null;
    }
  }

  Future<void> addUser(User user) async {
    await _db.collection('users').add(user.toMap());
  }

  Future<void> addProject(Project project) async {
    await _db.collection('projects').add(project.toJson());
  }

  Future<List<Project>> getProjects() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('projects').get();
    return snapshot.docs.map((doc) => Project.fromJson(doc.data())).toList();
  }

  Future<void> addTask(Task task) async {
    await _db.collection('tasks').add(task.toJson());
  }

  Future<List<Task>> getTasks() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection('tasks').get();
    return snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList();
  }
}