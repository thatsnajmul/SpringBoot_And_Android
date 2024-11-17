import 'package:flutter/material.dart';

import '../Service/AuthService.dart';


class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await authService.loginUser(
                    emailController.text,
                    passwordController.text,
                  );
                  print("Login successful: $response");
                } catch (e) {
                  print("Login failed: $e");
                }
              },
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
