import 'package:flutter/material.dart';
import 'package:flutter_app_imagineapps/api/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _password = '';

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nombre completo',
                  labelStyle: const TextStyle(
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es obligatorio.';
                  }

                  setState(() {
                    _name = value;
                  });

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  labelStyle: const TextStyle(
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El correo electrónico es obligatorio.';
                  }

                  setState(() {
                    _email = value;
                  });

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: const TextStyle(
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La contraseña es obligatoria.';
                  }

                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres.';
                  }

                  setState(() {
                    _password = value;
                  });

                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                child: const Text('Registrarse'),
                onPressed: () async {
                  // Validar el formulario
                  if (_formKey.currentState!.validate()) {
                    // Enviar la petición al servicio de autenticación
                    final getToken =
                        await _authService.register(_name, _email, _password);

                    // Guardar el token en el almacenamiento local
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('token', getToken['token']!);

                    // Si el token es nulo, significa que hubo un error al iniciar sesión
                    if (getToken['token'] == '') {
                      showErrorMessage(
                        'Las credenciales de inicio de sesión son incorrectas.',
                      );
                    } else {
                      // Guardar el token en el almacenamiento local y navegar a la pantalla principal
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('token', getToken['token']!);
                      Navigator.pushNamed(context, '/home');
                    }

                    // Navegar a la pantalla principal
                    Navigator.pushNamed(context, '/home');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
