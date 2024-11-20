import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'Login.dart'; // Ensure the Login screen file is imported
import 'User.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  User user = User("", "");
  String url = "http://localhost:8080/register";

  Future<void> save() async {
    try {
      var res = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': user.email, 'password': user.password}),
      );

      if (res.statusCode == 200) {
        print("User registered successfully");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()), // Navigate to Login
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Registration Failed"),
            content: Text("Failed to register. Please try again."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("An error occurred: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
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
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(233, 65, 82, 1),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black,
                      offset: const Offset(1, 5),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
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
                        "Register",
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
                        controller: TextEditingController(text: user.email),
                        onChanged: (val) {
                          user.email = val;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is empty';
                          }
                          return null;
                        },
                        style: const TextStyle(fontSize: 30, color: Colors.white),
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
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
                        controller: TextEditingController(text: user.password),
                        onChanged: (val) {
                          user.password = val;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is empty';
                          }
                          return null;
                        },
                        style: const TextStyle(fontSize: 30, color: Colors.white),
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Login()),
                            );
                          },
                          child: Text(
                            "Already have an Account?",
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                height: 90,
                width: 90,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(233, 65, 82, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
