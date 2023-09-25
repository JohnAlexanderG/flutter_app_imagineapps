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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nombre Completo',
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
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
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
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
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
              ElevatedButton(
                child: const Text('Registrarse'),
                onPressed: () async {
                  // Validar el formulario
                  if (_formKey.currentState!.validate()) {
                    // Enviar la petición al servicio de autenticación
                    final token =
                        await _authService.register(_name, _email, _password);

                    // Guardar el token en el almacenamiento local
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('token', token);

                    // Navegar a la pantalla principal
                    Navigator.pushNamed(context, '/home');
                  }
                },
              ),
              ElevatedButton(
                child: const Text('Iniciar sesión'),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
