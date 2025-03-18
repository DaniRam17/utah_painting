import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<String>> _tasksByDate = {};

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    QuerySnapshot taskSnapshot = await _db.collection('tasks').get();
    Map<DateTime, List<String>> tempTasks = {};
    for (var doc in taskSnapshot.docs) {
      DateTime date = (doc['startDate'] as Timestamp).toDate();
      tempTasks.putIfAbsent(date, () => []).add(doc['name']);
    }
    setState(() {
      _tasksByDate = tempTasks;
    });
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
                ? Center(child: Text('No hay tareas para este día'))
                : ListView.builder(
                    itemCount: _tasksByDate[_selectedDay]!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_tasksByDate[_selectedDay]![index]),
                        leading: Icon(Icons.check_circle, color: Colors.green),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}