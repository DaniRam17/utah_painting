import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _selectedUser;
  int totalProjects = 0;
  int totalTasks = 0;
  int completedTasks = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() async {
    QuerySnapshot projectSnapshot = await _db.collection('projects').get();
    QuerySnapshot taskSnapshot = await _db.collection('tasks').get();
    QuerySnapshot completedTaskSnapshot = await _db.collection('tasks').where('status', isEqualTo: 'Completada').get();
    
    setState(() {
      totalProjects = projectSnapshot.size;
      totalTasks = taskSnapshot.size;
      completedTasks = completedTaskSnapshot.size;
    });
  }

  void _filterByUser(String userId) async {
    QuerySnapshot projectSnapshot = await _db.collection('projects').where('assignedTo', isEqualTo: userId).get();
    QuerySnapshot taskSnapshot = await _db.collection('tasks').where('assignedTo', isEqualTo: userId).get();
    QuerySnapshot completedTaskSnapshot = await _db.collection('tasks').where('assignedTo', isEqualTo: userId).where('status', isEqualTo: 'Completada').get();
    
    setState(() {
      totalProjects = projectSnapshot.size;
      totalTasks = taskSnapshot.size;
      completedTasks = completedTaskSnapshot.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'), backgroundColor: Colors.blueAccent),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Resumen de Proyectos y Tareas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 20),
            StreamBuilder(
              stream: _db.collection('users').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                var users = snapshot.data!.docs;
                return DropdownButtonFormField(
                  value: _selectedUser,
                  items: users.map((user) {
                    return DropdownMenuItem(
                      value: user.id,
                      child: Text(user['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUser = value.toString();
                      _filterByUser(_selectedUser!);
                    });
                  },
                  decoration: InputDecoration(labelText: 'Filtrar por usuario', filled: true, fillColor: Colors.blueGrey[900], labelStyle: TextStyle(color: Colors.white)),
                );
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(color: Colors.blue, value: totalProjects.toDouble(), title: 'Proyectos'),
                    PieChartSectionData(color: Colors.green, value: completedTasks.toDouble(), title: 'Tareas Completas'),
                    PieChartSectionData(color: Colors.orange, value: (totalTasks - completedTasks).toDouble(), title: 'Pendientes'),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  Text('Total Proyectos', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('$totalProjects', style: TextStyle(fontSize: 20, color: Colors.blue)),
                ]),
                Column(children: [
                  Text('Tareas Completadas', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('$completedTasks', style: TextStyle(fontSize: 20, color: Colors.green)),
                ]),
                Column(children: [
                  Text('Tareas Pendientes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('${totalTasks - completedTasks}', style: TextStyle(fontSize: 20, color: Colors.orange)),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}