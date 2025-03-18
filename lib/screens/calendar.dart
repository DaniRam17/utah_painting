import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Map<String, dynamic>>> _tasksByDate = {};
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserTasks();
  }

  void _loadUserTasks() async {
    User? user = _auth.currentUser;
    if (user != null) {
      userId = user.uid;
      QuerySnapshot taskSnapshot = await _db.collection('tasks').where('assignedTo', isEqualTo: userId).get();
      Map<DateTime, List<Map<String, dynamic>>> tempTasks = {};
      for (var doc in taskSnapshot.docs) {
        DateTime date = (doc['startDate'] as Timestamp).toDate();
        tempTasks.putIfAbsent(date, () => []).add({
          'name': doc['name'],
          'status': doc['status'],
        });
      }
      setState(() {
        _tasksByDate = tempTasks;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendario'), backgroundColor: Colors.blueAccent),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            eventLoader: (day) {
              return _tasksByDate[day] ?? [];
            },
          ),
          SizedBox(height: 10),
          Expanded(
            child: _tasksByDate[_selectedDay] == null || _tasksByDate[_selectedDay]!.isEmpty
                ? Center(child: Text('No hay tareas para este día', style: TextStyle(color: Colors.white)))
                : ListView.builder(
                    itemCount: _tasksByDate[_selectedDay]!.length,
                    itemBuilder: (context, index) {
                      var task = _tasksByDate[_selectedDay]![index];
                      return Card(
                        color: Colors.blueGrey[900],
                        child: ListTile(
                          title: Text(task['name'], style: TextStyle(color: Colors.white)),
                          subtitle: Text('Estado: ${task['status']}', style: TextStyle(color: Colors.white70)),
                          leading: Icon(
                            task['status'] == 'Completada' ? Icons.check_circle : Icons.pending_actions,
                            color: task['status'] == 'Completada' ? Colors.green : Colors.orange,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
