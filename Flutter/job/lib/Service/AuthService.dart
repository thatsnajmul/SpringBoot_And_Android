import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const baseUrl = "http://localhost:8080"; // Replace with your backend URL

  Future<Map<String, dynamic>> registerUser(String type, Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register/$type"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to register user: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to log in: ${response.body}");
    }
  }
}
