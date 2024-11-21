import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_field/date_field.dart';
import 'package:http/http.dart' as http;

import 'package:job/LoginReg/Login.dart'; // Adjust the import path as necessary

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController cell = TextEditingController();
  final TextEditingController address = TextEditingController();
  final DateTimeFieldPickerPlatform dob = DateTimeFieldPickerPlatform.material;

  String? selectedGender;
  String? selectedRole;
  DateTime? selectedDOB;

  final _formKey = GlobalKey<FormState>();

  // Registration Method
  void _register() async {
    if (_formKey.currentState!.validate()) {
      String uName = name.text;
      String uEmail = email.text;
      String uPassword = password.text;
      String uCell = cell.text;
      String uAddress = address.text;
      String uGender = selectedGender ?? 'Other';
      String uDob = selectedDOB != null ? selectedDOB!.toIso8601String() : '';
      String uRole = selectedRole ?? 'JOB_SEEKER';

      // Determine the registration URL based on the role
      String url;
      if (uRole == 'JOB_SEEKER') {
        url = 'http://localhost:8080/register/job-seeker';
      } else if (uRole == 'EMPLOYER') {
        url = 'http://localhost:8080/register/employer';
      } else if (uRole == 'ADMIN') {
        url = 'http://localhost:8080/register/admin';
      } else {
        url = 'http://localhost:8080/register/job-seeker';
      }

      // Send data to the server
      final response = await _sendDataToBackend(
          url, uName, uEmail, uPassword, uCell, uAddress, uGender, uDob);

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Registration successful!');
      } else if (response.statusCode == 409) {
        print('User already exists!');
      } else {
        print('Registration failed with status: ${response.statusCode}');
      }
    }
  }

  // HTTP POST Request to send data to backend
  Future<http.Response> _sendDataToBackend(
      String url,
      String name,
      String email,
      String password,
      String cell,
      String address,
      String gender,
      String dob) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'cell': cell,
        'address': address,
        'gender': gender,
        'dob': dob,
      }),
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: name,
                  decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person)),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: email,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email)),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: password,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: confirmPassword,
                  decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: cell,
                  decoration: InputDecoration(
                      labelText: 'Cell Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone)),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: address,
                  decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.maps_home_work_rounded)),
                ),
                SizedBox(height: 20),
                DateTimeFormField(
                  decoration: const InputDecoration(labelText: 'Date of Birth'),
                  mode: DateTimeFieldPickerMode.date,
                  pickerPlatform: dob,
                  onChanged: (DateTime? value) {
                    setState(() {
                      selectedDOB = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Gender:'),
                    Radio<String>(
                      value: 'Male',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    Text('Male'),
                    Radio<String>(
                      value: 'Female',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    Text('Female'),
                    Radio<String>(
                      value: 'Other',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    Text('Other'),
                  ],
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: ['JOB_SEEKER', 'EMPLOYER', 'ADMIN']
                      .map((role) => DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline)),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  child: Text(
                    "Register",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.lato().fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}






// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:date_field/date_field.dart';
// import 'package:http/http.dart' as http;
// import 'package:job/LoginReg/Login.dart';
//
// class RegistrationPage extends StatefulWidget {
//   @override
//   State<RegistrationPage> createState() => _RegistrationPageState();
// }
//
// class _RegistrationPageState extends State<RegistrationPage> {
//   final TextEditingController name = TextEditingController();
//   final TextEditingController email = TextEditingController();
//   final TextEditingController password = TextEditingController();
//   final TextEditingController confirmPassword = TextEditingController();
//   final TextEditingController cell = TextEditingController();
//   final TextEditingController address = TextEditingController();
//   final DateTimeFieldPickerPlatform dob = DateTimeFieldPickerPlatform.material;
//
//   String? selectedGender;
//   String? selectedRole; // Added for role selection
//   DateTime? selectedDOB;
//
//   final _formKey = GlobalKey<FormState>();
//
//   // Registration Method
//   void _register() async {
//     if (_formKey.currentState!.validate()) {
//       String uName = name.text;
//       String uEmail = email.text;
//       String uPassword = password.text;
//       String uCell = cell.text;
//       String uAddress = address.text;
//       String uGender = selectedGender ?? 'Other';
//       String uDob = selectedDOB != null ? selectedDOB!.toIso8601String() : '';
//       String uRole = selectedRole ?? 'JOB_SEEKER';
//
//       // Determine the registration URL based on the role
//       String url;
//       if (uRole == 'JOB_SEEKER') {
//         url = 'http://localhost:8080/register/job-seeker';
//       } else if (uRole == 'EMPLOYER') {
//         url = 'http://localhost:8080/register/employer';
//       } else if(uRole == 'ADMIN'){
//         url = 'http://localhost:8080/register/admin';
//       } else {
//         url = 'http://localhost:8080/register/job-seeker';
//       }
//
//       // Send data to the server
//       final response = await _sendDataToBackend(
//           url, uName, uEmail, uPassword, uCell, uAddress, uGender, uDob);
//
//       if (response.statusCode == 201 || response.statusCode == 200) {
//         // Registration successful
//         print('Registration successful!');
//       } else if (response.statusCode == 409) {
//         print('User already exists!');
//       } else {
//         print('Registration failed with status: ${response.statusCode}');
//       }
//     }
//   }
//
//   // HTTP POST Request to send data to backend
//   Future<http.Response> _sendDataToBackend(
//       String url,
//       String name,
//       String email,
//       String password,
//       String cell,
//       String address,
//       String gender,
//       String dob) async {
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': name,
//         'email': email,
//         'password': password,
//         'cell': cell,
//         'address': address,
//         'gender': gender,
//         'dob': dob,
//       }),
//     );
//     return response;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextField(
//                   controller: name,
//                   decoration: InputDecoration(
//                       labelText: 'Full Name',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.person)),
//                 ),
//                 SizedBox(height: 20),
//                 TextField(
//                   controller: email,
//                   decoration: InputDecoration(
//                       labelText: 'Email',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.email)),
//                 ),
//                 SizedBox(height: 20),
//                 TextField(
//                   controller: password,
//                   decoration: InputDecoration(
//                       labelText: 'Password',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.lock)),
//                   obscureText: true,
//                 ),
//                 SizedBox(height: 20),
//                 TextField(
//                   controller: confirmPassword,
//                   decoration: InputDecoration(
//                       labelText: 'Confirm Password',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.lock)),
//                   obscureText: true,
//                 ),
//                 SizedBox(height: 20),
//                 TextField(
//                   controller: cell,
//                   decoration: InputDecoration(
//                       labelText: 'Cell Number',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.phone)),
//                 ),
//                 SizedBox(height: 20),
//                 TextField(
//                   controller: address,
//                   decoration: InputDecoration(
//                       labelText: 'Address',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.maps_home_work_rounded)),
//                 ),
//                 SizedBox(height: 20),
//                 DateTimeFormField(
//                   decoration: const InputDecoration(labelText: 'Date of Birth'),
//                   mode: DateTimeFieldPickerMode.date,
//                   pickerPlatform: dob,
//                   onChanged: (DateTime? value) {
//                     setState(() {
//                       selectedDOB = value;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Text('Gender:'),
//                     Radio<String>(
//                       value: 'Male',
//                       groupValue: selectedGender,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedGender = value;
//                         });
//                       },
//                     ),
//                     Text('Male'),
//                     Radio<String>(
//                       value: 'Female',
//                       groupValue: selectedGender,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedGender = value;
//                         });
//                       },
//                     ),
//                     Text('Female'),
//                     Radio<String>(
//                       value: 'Other',
//                       groupValue: selectedGender,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedGender = value;
//                         });
//                       },
//                     ),
//                     Text('Other'),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 DropdownButtonFormField<String>(
//                   value: selectedRole,
//                   items: ['JOB_SEEKER', 'EMPLOYER', 'ADMIN']
//                       .map((role) => DropdownMenuItem(
//                     value: role,
//                     child: Text(role),
//                   ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedRole = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                       labelText: 'Role',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.person_outline)),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _register,
//                   child: Text(
//                     "Register",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontFamily: GoogleFonts.lato().fontFamily,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
