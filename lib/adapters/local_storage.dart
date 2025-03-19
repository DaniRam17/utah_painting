import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import '../models/project.dart';
import '../models/task.dart';

class LocalStorage {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Guardar estado de autenticación
  static Future<void> setLoginStatus(bool status) async {
    await _prefs.setBool("isAuthenticated", status);
  }

  /// Obtener estado de autenticación
  static bool getLoginStatus() {
    return _prefs.getBool("isAuthenticated") ?? false;
  }

  /// Guardar información del usuario
  static Future<void> setUser(UserModel user) async {
    String userJson = jsonEncode(user.toMap());
    await _prefs.setString("user", userJson);
  }

  /// Obtener información del usuario
  static UserModel? getUser() {
    String? userJson = _prefs.getString("user");
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return UserModel.fromMap(userMap);
    }
    return null;
  }

  /// Guardar lista de proyectos en caché
  static Future<void> setProjects(List<ProjectModel> projects) async {
    List<String> projectsJson = projects.map((p) => jsonEncode(p.toFirestore())).toList();
    await _prefs.setStringList("projects", projectsJson);
  }

  /// Obtener lista de proyectos desde caché
  static List<ProjectModel>? getProjects() {
    List<String>? projectsJson = _prefs.getStringList("projects");
    if (projectsJson != null) {
      return projectsJson.map((p) => ProjectModel.fromFirestore(jsonDecode(p))).toList();
    }
    return null;
  }

  /// Guardar lista de tareas en caché
  static Future<void> setTasks(List<TaskModel> tasks) async {
    List<String> tasksJson = tasks.map((t) => jsonEncode(t.toFirestore())).toList();
    await _prefs.setStringList("tasks", tasksJson);
  }

  /// Obtener lista de tareas desde caché
  static List<TaskModel>? getTasks() {
    List<String>? tasksJson = _prefs.getStringList("tasks");
    if (tasksJson != null) {
      return tasksJson.map((t) => TaskModel.fromFirestore(jsonDecode(t))).toList();
    }
    return null;
  }

  /// Limpiar datos almacenados
  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}
