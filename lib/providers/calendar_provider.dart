import 'package:flutter/material.dart';

class CalendarProvider extends ChangeNotifier {
  Map<DateTime, List<Map<String, String>>> _events = {};

  Map<DateTime, List<Map<String, String>>> get events => _events;

  void addEvent(DateTime date, Map<String, String> event) {
    if (!_events.containsKey(date)) {
      _events[date] = [];
    }
    _events[date]!.add(event);
    notifyListeners();
  }

  void removeEvent(DateTime date, String eventName) {
    _events[date]?.removeWhere((event) => event['task'] == eventName);
    notifyListeners();
  }
}