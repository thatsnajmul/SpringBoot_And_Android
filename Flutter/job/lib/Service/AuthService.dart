import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/LoginRequest.dart';
import '../Model/User.dart';

class AuthService {
  final String baseUrl = "http://localhost:8080/api/auth";

  Future<void> register(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to register');
    }
  }

  Future<User?> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      // Assuming the response contains user data
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<User?> getCurrentUser(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/current'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    }
    return null;
  }
}
