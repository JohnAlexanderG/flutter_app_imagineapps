import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl = 'http://192.168.0.21:3080/api';

  Uri uri(String path) => Uri.parse('$_baseUrl/$path');

  Future<String> register(String name, String email, String password) async {
    Uri url = uri('users/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'name': name,
      'email': email,
      'password': password,
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Error al registrar el usuario');
    }
  }

  Future<Map<String, String>> login(String email, String password) async {
    Uri url = uri('users/login');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print(response.body);
      return Map.from({'token': response.body});
    } else {
      return Map.from({'token': ''});
    }
  }
}
