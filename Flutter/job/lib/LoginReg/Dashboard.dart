import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  final int userId; // Pass user ID to Dashboard

  const Dashboard({required this.userId}); // Use named parameter

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, dynamic>? userData; // To store user data
  bool isLoading = true; // To show a loading indicator
  String? errorMessage; // For error messages

  @override
  void initState() {
    super.initState();
    fetchUserData(widget.userId); // Fetch user data on page load
  }

  // Fetch user data by ID
  Future<void> fetchUserData(int userId) async {
    final url = Uri.parse('http://localhost:8080/users/$userId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          userData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "Failed to load user data. Status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error fetching user data: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader while fetching data
          : errorMessage != null
          ? Center(
        child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
      )
          : userData != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "User Details",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text("ID: ${userData!['id']}", style: const TextStyle(fontSize: 18)),
            Text("Email: ${userData!['email']}", style: const TextStyle(fontSize: 18)),
            Text("Username: ${userData!['username']}", style: const TextStyle(fontSize: 18)),
            // Add more fields if available
          ],
        ),
      )
          : const Center(child: Text("No user data found!")),
    );
  }
}
