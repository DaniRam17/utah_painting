import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../adapters/local_storage.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Obtener datos de un usuario por UID
  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _db.collection('users').doc(uid).get();
      if (snapshot.exists) {
        UserModel user = UserModel.fromMap(snapshot.data()!);
        await LocalStorage.setUser(user); // Guardar en local storage
        return user;
      }
      return null;
    } catch (e) {
      print('Error obteniendo usuario: $e');
      return null;
    }
  }

  /// Obtener todos los usuarios
  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      QuerySnapshot snapshot = await _db.collection('users').get();
      return snapshot.docs.map((doc) => {
        'uid': doc.id,
        'name': doc['name'] ?? ''
      }).toList();
    } catch (e) {
      print('Error obteniendo usuarios: $e');
      return [];
    }
  }

  /// Crear un usuario en Firestore y almacenarlo localmente
  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.uid).set(user.toMap());
      await LocalStorage.setUser(user); // Guardar en local storage
    } catch (e) {
      print('Error creando usuario: $e');
    }
  }

  /// Obtener proyectos desde Firestore y almacenarlos en caché
  Future<List<ProjectModel>> getProjects() async {
    try {
      QuerySnapshot snapshot = await _db.collection('projects').get();
      return snapshot.docs.map((doc) => ProjectModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error obteniendo proyectos: $e');
      return [];
    }
  }

  /// Crear un proyecto en Firestore
  Future<void> createProject(ProjectModel project) async {
    try {
      await _db.collection('projects').add(project.toFirestore());
    } catch (e) {
      print('Error creando proyecto: $e');
    }
  }

  /// Obtener todas las tareas y almacenarlas en caché
  Future<List<TaskModel>> getTasks() async {
    try {
      QuerySnapshot snapshot = await _db.collection('tasks').get();
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error obteniendo tareas: $e');
      return [];
    }
  }

  /// Crear una tarea en Firestore
  Future<void> createTask(TaskModel task) async {
    try {
      await _db.collection('tasks').add(task.toFirestore());
    } catch (e) {
      print('Error creando tarea: $e');
    }
  }

  /// Actualizar un proyecto
  Future<void> updateProject(String projectId, Map<String, dynamic> data) async {
    try {
      await _db.collection('projects').doc(projectId).update(data);
    } catch (e) {
      print('Error actualizando proyecto: $e');
    }
  }

  /// Actualizar una tarea
  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    try {
      await _db.collection('tasks').doc(taskId).update(data);
    } catch (e) {
      print('Error actualizando tarea: $e');
    }
  }

  /// Eliminar un proyecto
  Future<void> deleteProject(String projectId) async {
    try {
      await _db.collection('projects').doc(projectId).delete();
    } catch (e) {
      print('Error eliminando proyecto: $e');
    }
  }

  /// Eliminar una tarea
  Future<void> deleteTask(String taskId) async {
    try {
      await _db.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print('Error eliminando tarea: $e');
    }
  }
}
