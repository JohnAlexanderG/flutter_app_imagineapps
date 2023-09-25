import 'package:flutter/material.dart';
import 'package:flutter_app_imagineapps/screens/create_task_screen.dart';
import 'package:flutter_app_imagineapps/screens/login_screen.dart';
import 'package:flutter_app_imagineapps/screens/signup_screen.dart';
import 'package:flutter_app_imagineapps/screens/task_details_screen.dart';
import 'package:flutter_app_imagineapps/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Imagine Apps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/create-task': (context) => const CreateTaskScreen(),
        '/edit-task': (context) => const TaskDetailScreen(),
      },
    );
  }
}
