import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // const TasksScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<dynamic> tasks = [];
  int _selectedIndex = 0;

  Map<String, dynamic> _decodedToken = {};

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
    final response = await http.get(
      Uri.parse(
          'http://192.168.0.21:3080/api/users/getAllTasksByUserId/${decodedToken['id']}'),
      headers: {
        'Authorization': 'Bearer ${jsonTokenDecode['token']}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      tasks = data;
    } else {
      throw Exception('Error al obtener las tareas');
    }

    setState(() {
      _decodedToken = decodedToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return [
      Scaffold(
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
        bottomNavigationBar: bottomNavigationBarSelect(),
        body: Builder(
          builder: (context) {
            if (tasks.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No hay tareas', style: TextStyle(fontSize: 20)),
                    Text('Cuando agregues una tarea aparecerá aquí',
                        style: TextStyle(fontSize: 10)),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task['title']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Estado: ${task['status']}'),
                      Text(
                          'Vencimiento: ${task['due_date'].toString().substring(0, 10)}'),
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
            );
          },
        ),
      ),
      Scaffold(
        appBar: AppBar(
          title: const Text('Ajustes'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () async {
                final localToken = await SharedPreferences.getInstance();
                localToken.remove('token');
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
        bottomNavigationBar: bottomNavigationBarSelect(),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text(_decodedToken['name'] ?? ''),
            subtitle: Text(_decodedToken['email'] ?? ''),
            trailing: Icon(Icons.verified_rounded,
                color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    ][_selectedIndex];
  }

  BottomNavigationBar bottomNavigationBarSelect() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.task),
          label: 'Tareas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Ajustes',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}
