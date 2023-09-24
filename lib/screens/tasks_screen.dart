import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  // const TasksScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late List<dynamic> tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final localToken = await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString('token');
    });
    final jsonTokenDecode = jsonDecode(localToken!);
    final decodedToken = JwtDecoder.decode(jsonTokenDecode['token']);
    print('decodedToken: $decodedToken');
    final response = await http.get(
      Uri.parse(
          'http://192.168.0.21:3080/api/users/getAllTasksByUserId/${decodedToken['id']}'),
      headers: {
        'Authorization': 'Bearer ${jsonTokenDecode['token']}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // tasks = data.map((task) => TasksType.fromJson(task)).toList();
      tasks = data;
      // print('data: $data');
    } else {
      throw Exception('Error al obtener las tareas');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task),
            onPressed: () {
              Navigator.pushNamed(context, '/create-task');
              // _fetchTasks();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task['title']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estado: ${task['status']}'),
                Text('Vencimiento: ${task['dueDate']}'),
                Text('${task['description']}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Navegar a la pantalla de edición de tareas
                    Navigator.pushNamed(
                      context,
                      '/edit-task',
                      arguments: task,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
