import 'package:flutter/foundation.dart';
import 'package:flutter_app_imagineapps/api/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TasksService {
  final _tasks = <TasksType>[];

  List<TasksType> get tasks => _tasks;

  void addTask(TasksType task) {
    _tasks.add(task);
  }

  void removeTask(TasksType task) {
    _tasks.remove(task);
  }

  Future<String> getAllTasksByUserId() async {
    final token = await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString('token');
    });

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);

    if (kDebugMode) {
      print(decodedToken);
    }

    // return _tasks.where((task) => task.userId == userId).toList();
    return 'from getAllTasksByUserId';
  }
}
