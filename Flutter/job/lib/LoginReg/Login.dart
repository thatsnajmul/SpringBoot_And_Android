import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job/job/public/jobDrawer.dart';
import 'package:job/main.dart';
import 'dashboard.dart'; // Ensure correct import path

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String url = "http://localhost:8080/login";

  Future<void> save() async {
    try {
      var res = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (res.statusCode == 200) {
        final responseData = json.decode(res.body);
        final int userId = responseData['id']; // Ensure backend returns `id`
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(), // Pass userId here
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Login Failed"),
            content: const Text("Invalid email or password."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text("An error occurred: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 750,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(233, 65, 82, 1),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        color: Colors.black,
                        offset: Offset(1, 5))
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(80),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      Text(
                        "Login",
                        style: GoogleFonts.pacifico(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Email",
                          style: GoogleFonts.roboto(
                            fontSize: 40,
                            color: const Color.fromRGBO(255, 255, 255, 0.8),
                          ),
                        ),
                      ),
                      TextFormField(
                        onChanged: (val) => email = val,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is empty';
                          }
                          return null;
                        },
                        style: const TextStyle(fontSize: 30, color: Colors.white),
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(fontSize: 20, color: Colors.black),
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                      Container(
                        height: 8,
                        color: const Color.fromRGBO(255, 255, 255, 0.4),
                      ),
                      const SizedBox(height: 60),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Password",
                          style: GoogleFonts.roboto(
                            fontSize: 40,
                            color: const Color.fromRGBO(255, 255, 255, 0.8),
                          ),
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        onChanged: (val) => password = val,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is empty';
                          }
                          return null;
                        },
                        style: const TextStyle(fontSize: 30, color: Colors.white),
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(fontSize: 20, color: Colors.black),
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                      Container(
                        height: 8,
                        color: const Color.fromRGBO(255, 255, 255, 0.4),
                      ),
                      const SizedBox(height: 60),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/register'); // Example: Register screen
                          },
                          child: Text(
                            "Don't have an account?",
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 90,
                width: 90,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color.fromRGBO(233, 65, 82, 1),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      save();
                    }
                  },
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
