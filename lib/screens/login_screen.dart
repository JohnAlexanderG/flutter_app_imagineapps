import 'package:flutter/material.dart';
import 'package:flutter_app_imagineapps/api/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
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
                child: const Text('Iniciar sesión'),
                onPressed: () async {
                  // Validar el formulario
                  if (_formKey.currentState!.validate()) {
                    // Enviar la petición al servicio de autenticación
                    final token = await _authService.login(_email, _password);

                    // Guardar el token en el almacenamiento local
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('token', token);

                    // Navegar a la pantalla principal
                    Navigator.pushNamed(context, '/register');
                  }
                },
              ),
              ElevatedButton(
                child: const Text('Registrarse'),
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}