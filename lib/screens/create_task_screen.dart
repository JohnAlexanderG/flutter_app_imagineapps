import 'package:flutter/material.dart';
import 'package:flutter_app_imagineapps/api/models/task_model.dart';
import 'package:flutter_app_imagineapps/api/services/tasks_service.dart';
import 'package:flutter_app_imagineapps/screens/tasks_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  List<DropdownMenuItem<dynamic>> list = [
    const DropdownMenuItem(
      value: 1,
      child: Text('Pendiente'),
    ),
    const DropdownMenuItem(
      value: 2,
      child: Text('En proceso'),
    ),
    const DropdownMenuItem(
      value: 3,
      child: Text('Completada'),
    ),
  ];

  void _showDatePicker() {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return CalendarDatePicker(
          initialDate: DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
          ),
          firstDate: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
          lastDate: DateTime(
            DateTime.now().year + 1,
            DateTime.now().month + 1,
          ),
          onDateChanged: (date) {
            setState(() {
              selectedDate = date;
              Navigator.pop(context); // Cierra el modal
            });
          },
        );
      },
    );
  }

  String _title = '';
  String _description = '';
  int _state = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Título',
                    labelStyle: const TextStyle(
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El título es obligatorio.';
                    }
                    setState(() {
                      _title = value;
                    });
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: const TextStyle(
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción es obligatoria.';
                    }
                    setState(() {
                      _description = value;
                    });
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: selectedDate.toString().substring(0, 10),
                  ),
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.calendar_today),
                    labelText: 'Fecha de entrega',
                    labelStyle: const TextStyle(
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La fecha de entrega es obligatoria.';
                    }
                    return null;
                  },
                  onTap: _showDatePicker,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  items: list,
                  validator: (value) {
                    if (value == null || value == 0) {
                      return 'El estado es obligatorio.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _state = value as int;
                    });
                  },
                  hint: const Text('Estado'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.only(
                            top: 16, bottom: 16, left: 32, right: 32)),
                  ),
                  onPressed: () async {
                    final token =
                        await SharedPreferences.getInstance().then((prefs) {
                      return prefs.getString('token');
                    });

                    Map<String, dynamic> decodedToken =
                        JwtDecoder.decode(token!);

                    // Validar el formulario
                    if (_formKey.currentState!.validate()) {
                      // Enviar la petición al servicio de autenticación
                      final response = await TasksService().createTask(
                        TasksType(
                          userId: decodedToken['id'],
                          title: _title,
                          description: _description,
                          dueDate: selectedDate.toString().substring(0, 10),
                          status: _state,
                        ),
                      );

                      response == 'Tarea creada'
                          ? {
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return const TasksScreen();
                                }),
                              ),
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('Se ha creado una nueva tarea'),
                                ),
                              )
                            }
                          // ignore: use_build_context_synchronously
                          : ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  'Error al crear la tarea',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                    }
                  },
                  child: const Text(
                    'Crear tarea',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
