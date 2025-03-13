import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  List<Map<String, String>> _notifications = [];

  List<Map<String, String>> get notifications => _notifications;

  void addNotification(String title, String message) {
    _notifications.add({'title': title, 'message': message});
    notifyListeners();
  }

  void removeNotification(String title) {
    _notifications.removeWhere((notification) => notification['title'] == title);
    notifyListeners();
  }
}