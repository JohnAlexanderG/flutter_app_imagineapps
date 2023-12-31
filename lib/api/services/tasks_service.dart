import 'dart:convert';

import 'package:flutter_app_imagineapps/api/models/task_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TasksService {
  final _tasks = <TasksType>[];

  final String _baseUrl = 'http://192.168.0.21:3080/api';
  Uri uri(String path) => Uri.parse('$_baseUrl/$path');

  List<TasksType> get tasks => _tasks;

  void addTask(TasksType task) {
    _tasks.add(task);
  }

  void removeTask(TasksType task) {
    _tasks.remove(task);
  }

  Future<String> createTask(TasksType task) async {
    final token = await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString('token');
    });

    final jsonToken = jsonDecode(token!);

    Uri url = uri('users/createTask');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${jsonToken['token']}',
    };
    final body = jsonEncode({
      "user_id": task.userId,
      "title": task.title,
      "description": task.description,
      "due_date": task.dueDate,
      "status": task.status
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception('Error al registrar el usuario');
    }
  }

  Future<String> editTask(TasksType task) async {
    final token = await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString('token');
    });

    final jsonToken = jsonDecode(token!);

    Uri url = uri('users/editTask');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${jsonToken['token']}',
    };
    final body = jsonEncode({
      "id": task.id,
      "title": task.title,
      "description": task.description,
      "due_date": task.dueDate,
      "status": task.status
    });

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception('Error al registrar el usuario');
    }
  }

  Future<String> deleteTask(TasksType task) async {
    final token = await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString('token');
    });

    final jsonToken = jsonDecode(token!);

    Uri url = uri('users/deleteTask');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${jsonToken['token']}',
    };
    final body = jsonEncode({
      "id": task.id,
    });

    final response = await http.delete(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception('Error al registrar el usuario');
    }
  }
}
