import 'package:flutter/material.dart';
import 'package:flutter_app_imagineapps/api/models/task_model.dart';
import 'package:flutter_app_imagineapps/api/services/tasks_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
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

  void _showDatePicker(String initialDate) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return CalendarDatePicker(
          initialDate: DateTime(
            DateTime.parse(initialDate).year,
            DateTime.parse(initialDate).month,
            DateTime.parse(initialDate).day,
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
              _changeAlternateDefaultValue = true;
            });
          },
        );
      },
    );
  }

  String _title = '';
  String _description = '';
  int _state = 0;
  bool _changeAlternateDefaultValue = false;
  bool _changeAlternateDefaultValueState = false;

  @override
  Widget build(BuildContext context) {
    RouteSettings settings = ModalRoute.of(context)!.settings;
    final task = settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                TextFormField(
                  initialValue: task['title'],
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
                  initialValue: task['description'],
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
                    text: _changeAlternateDefaultValue
                        ? selectedDate.toString().substring(0, 10)
                        : task['due_date'].toString().substring(0, 10),
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
                  onTap: () {
                    final dateDue = _changeAlternateDefaultValue
                        ? selectedDate.toString().substring(0, 10)
                        : task['due_date'].toString().substring(0, 10);
                    _showDatePicker(dateDue);
                  },
                  onEditingComplete: () {},
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  items: list,
                  value: task['status'],
                  validator: (value) {
                    if (value == null || value == 0) {
                      return 'El estado es obligatorio.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _changeAlternateDefaultValueState = true;
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
                const SizedBox(height: 32),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.only(
                            top: 16,
                            bottom: 16,
                            left: 32,
                            right: 32,
                          ),
                        ),
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
                          final response = await TasksService().editTask(
                            TasksType(
                              id: task['id'],
                              title: _title,
                              description: _description,
                              dueDate: selectedDate.toString().substring(0, 10),
                              status: _changeAlternateDefaultValueState
                                  ? _state
                                  : task['status'],
                            ),
                          );

                          response == 'Tarea actualizada'
                              // ignore: use_build_context_synchronously
                              // ? Navigator.pop(context)
                              // ignore: use_build_context_synchronously
                              ? ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Se ha editado la tarea'),
                                  ),
                                )
                              // ignore: use_build_context_synchronously
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Error al crear la tarea'),
                                  ),
                                );
                        }
                      },
                      child: const Text(
                        'Editar tarea',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextButton(
                      onPressed: () async {},
                      child: const Text(
                        'Eliminar tarea',
                        style: TextStyle(
                            fontSize: 16, color: Colors.deepOrangeAccent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
