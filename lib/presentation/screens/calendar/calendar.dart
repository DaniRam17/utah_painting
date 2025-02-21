import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Map<DateTime, List<Map<String, String>>> _events;
  late List<Map<String, String>> _selectedEvents;
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _selectedYear = DateTime.now().year;
    _selectedEvents = [];
    _events = {
      DateTime.utc(2025, 2, 20): [
        {'task': 'Tarea 1', 'user': 'Usuario 1', 'color': '0xFF42A5F5'},
        {'task': 'Tarea 2', 'user': 'Usuario 2', 'color': '0xFF66BB6A'},
      ],
      DateTime.utc(2025, 2, 21): [
        {'task': 'Tarea 3', 'user': 'Usuario 3', 'color': '0xFFFF7043'},
      ],
      DateTime.utc(2025, 2, 22): [
        {'task': 'Tarea 4', 'user': 'Usuario 4', 'color': '0xFFAB47BC'},
        {'task': 'Tarea 5', 'user': 'Usuario 5', 'color': '0xFFFFD54F'},
        {'task': 'Tarea 6', 'user': 'Usuario 6', 'color': '0xFF26A69A'},
      ],
    };
  }

  List<Map<String, String>> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://cdn0.iconfinder.com/data/icons/man-avatars-flat-icon-1/128/Man_11-512.png'), // URL de la imagen del perfil
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<int>(
              value: _selectedYear,
              icon: Icon(Icons.arrow_downward, color: const Color.fromARGB(255, 14, 14, 14)),
              dropdownColor: Colors.blue,
              underline: Container(
                height: 2,
                color: Colors.transparent,
              ),
              onChanged: (int? newValue) {
                setState(() {
                  _selectedYear = newValue!;
                  _focusedDay = DateTime(_selectedYear, _focusedDay.month, _focusedDay.day);
                });
              },
              items: List.generate(11, (index) => 2020 + index).map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents = _getEventsForDay(selectedDay);
              });
            },
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(color: Colors.red),
              holidayTextStyle: TextStyle(color: Colors.green),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
              headerPadding: EdgeInsets.symmetric(vertical: 8.0),
              headerMargin: EdgeInsets.symmetric(vertical: 8.0),
              leftChevronMargin: EdgeInsets.only(left: 8.0),
              rightChevronMargin: EdgeInsets.only(right: 8.0),
              leftChevronPadding: EdgeInsets.all(0),
              rightChevronPadding: EdgeInsets.all(0),
              leftChevronVisible: true,
              rightChevronVisible: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16.0),
              ),
              formatButtonTextStyle: TextStyle(color: Colors.white),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildEventsMarker(date, events),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedEvents.length,
              itemBuilder: (context, index) {
                final event = _selectedEvents[index];
                final color = Color(int.parse(event['color']!));
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  color: color.withOpacity(0.2),
                  child: ListTile(
                    title: Text(event['task']!),
                    subtitle: Text('Asignado a: ${event['user']}'),
                    leading: Icon(Icons.event, color: color),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}