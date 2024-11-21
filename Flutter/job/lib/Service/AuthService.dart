import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../LoginReg/User.dart';

class AuthService {

  final String baseUrl = 'http://localhost:8080';


  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({'email': email, 'password': password});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['token'];

      // Decode token to get role
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      String role = payload['role'];

      // Store token and role
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);
      await prefs.setString('userRole', role);

      return true;
    } else {
      print('Failed to log in: ${response.body}');
      return false;
    }
  }


  Future<bool> register(Map<String, dynamic> user) async {
    final url = Uri.parse('$baseUrl/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(user);

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['token'];
      Map<String, dynamic> currentUserMap = data['user'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);
      await prefs.setString('user', jsonEncode(currentUserMap));

      return true;
    } else {
      print('Failed to register: ${response.body}');
      return false;
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<String?> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('userRole'));
    return prefs.getString('userRole');
  }

  Future<bool> isTokenExpired() async {
    String? token = await getToken();
    if (token != null) {
      DateTime expiryDate = Jwt.getExpiryDate(token)!;
      return DateTime.now().isAfter(expiryDate);
    }
    return true;
  }

  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    if (token != null && !(await isTokenExpired())) {
      return true;
    } else {
      await logout();
      return false;
    }
  }

  Future<User?> getStoredUser() async {
    final sp = await SharedPreferences.getInstance();
    final userJson = sp.getString("user");
    if (userJson != null) {
      User user = User.fromJson(jsonDecode(userJson));
      return user;
    } else {
      return null;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('userRole');
  }

  Future<bool> hasRole(List<String> roles) async {
    String? role = await getUserRole();
    return role != null && roles.contains(role);
  }

  Future<bool> isAdmin() async {
    return await hasRole(['ADMIN']);
  }

  Future<bool> isEmployer() async {
    return await hasRole(['EMPLOYER']);
  }

  Future<bool> isJobSeeker() async {
    return await hasRole(['JOB_SEEKER']);
  }


}