import 'package:flutter/material.dart';
import 'dart:async';

import '../models/project.dart';
import '../adapters/dio_adapter.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // states
  late List<Project> _projectsState;
  bool _hasLoaded = false;
  // values

  List<Project> _projects = [];
  DioAdapter _dioAdapter = DioAdapter();

  @override
  void initState() {
    super.initState();
    _setProjects(null);
  }

  Future<void> _setProjects(String? status) async {
    List<Project> p;
    setState(() {
      _hasLoaded = false;
    });
    if (status != null) {
      p = _projects.where((proj) => proj.status == status).toList();
    } else {
      dynamic response = await _dioAdapter.getRequest("https://firestore.googleapis.com/v1/projects/utahpainting-17/databases/(default)/documents/projects");
      List<dynamic> documents = response["documents"];
      _projects = documents.map((doc) => Project.fromJson(doc)).toList();
      p = _projects;
    }

    setState(() {
      _projectsState = p;
      _hasLoaded = true;
    });
  }

  List<Widget> projectsListTile() {
    List<Widget> pWidgetTile = [];
    for (final p in _projectsState) {
      pWidgetTile.add(_ProjectTile(project: p));
      pWidgetTile.add(Divider(height: 0));
    }
    return pWidgetTile;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasLoaded) return _SearchLoading();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Project"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: () {
                _setProjects("Pendiente Asignacion");
              }, child: const Text("Pendiente Asignacion")),
              ElevatedButton(onPressed: () {
                _setProjects("En Proceso");
              }, child: const Text("En Proceso")),
              ElevatedButton(onPressed: () {
                _setProjects("Completado");
              }, child: const Text("Completado")),
              ElevatedButton(onPressed: () {
                _setProjects("Anulado");
              }, child: const Text("Anulado")),
            ],
          ),
          Expanded(
            child: ListView(
              children: [...projectsListTile()],
            ),
          ),
        ],
      ),
    );
  }
}

// stateless widget

class _SearchLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Project"),
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  final Project project;

  const _ProjectTile({
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.business),
      title: Row(
        children: [
          Text(project.name),
          SizedBox(width: 5),
          Text(
            project.status,
            style: TextStyle(
              fontSize: 14,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      subtitle: Text(project.description),
      trailing: IconButton(
        onPressed: () {
          print("Delete project");
        },
        icon: Icon(Icons.delete),
      ),
    );
  }
}