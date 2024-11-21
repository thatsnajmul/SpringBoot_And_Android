import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:job/AdminPage.dart';
import 'package:job/EmployerPage.dart';
import 'package:job/LoginReg/RegisterScreen.dart';
import 'package:job/main.dart';

import '../Service/AuthService.dart';


class LoginPage extends StatelessWidget {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final storage = FlutterSecureStorage();
  final AuthService authService = AuthService();

  Future<void> loginUser(BuildContext context) async {
    try {
      final response = await authService.login(name.text, email.text, password.text);

      // Mock response - replace with actual API response
      final String? role = await authService.getUserRole(); // Example: "JOB_SEEKER"
      final String userName = name.text; // Replace with API-provided name or username
      final String userEmail = email.text; // Replace with API-provided email

      // Save user details securely
      await storage.write(key: 'user_role', value: role);
      await storage.write(key: 'user_name', value: userName);
      await storage.write(key: 'user_email', value: userEmail);

      // Navigate based on role
      if (role == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else if (role == 'EMPLOYER') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EmployerPage()),
        );
      } else if (role == 'JOB_SEEKER') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        print('Unknown role: $role');
      }
    } catch (error) {
      print('Login failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String?>(
          future: storage.read(key: 'user_name'),  // Retrieve the user name from storage
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            } else if (snapshot.hasData && snapshot.data != null) {
              return Text(
                'Welcome, ${snapshot.data}',
                style: GoogleFonts.lato(),
              );
            } else {
              return Text(
                'Login',
                style: GoogleFonts.lato(),
              );
            }
          },
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: password,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                loginUser(context);
              },
              child: Text(
                "Login",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.lato().fontFamily,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: Text(
                'Registration',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:job/EmployerPage.dart';
// import 'package:job/LoginReg/RegisterScreen.dart';
// import 'package:job/job/public/jobDrawer.dart';
// import 'package:job/main.dart';
//
// import '../AdminPage.dart';
// import '../Service/AuthService.dart';
//
//
//
// class LoginPage extends StatelessWidget {
//
//   final TextEditingController name = TextEditingController();
//   final TextEditingController email = TextEditingController();
//   final TextEditingController password = TextEditingController();
//   final storage = new FlutterSecureStorage();
//   AuthService authService=AuthService();
//
//   Future<void> loginUser(BuildContext context) async {
//     try {
//       final response = await authService.login(email.text, password.text);
//
//       // Mock response - replace with actual API response
//       final String? role = await authService.getUserRole(); // Example: "JOB_SEEKER"
//       final String userName = name.text; // Replace with API-provided name
//       final String userEmail = email.text; // Replace with API-provided email
//
//       // Save user details securely
//       await storage.write(key: 'user_role', value: role);
//       await storage.write(key: 'user_name', value: userName);
//       await storage.write(key: 'user_email', value: userEmail);
//
//       // Navigate based on role
//       if (role == 'ADMIN') {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => AdminPage()),
//         );
//       } else if (role == 'EMPLOYER') {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => EmployerPage()),
//         );
//       } else if (role == 'JOB_SEEKER') {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomeScreen()),
//         );
//       } else {
//         print('Unknown role: $role');
//       }
//     } catch (error) {
//       print('Login failed: $error');
//       // Display error dialog/snackbar if needed
//     }
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: email,
//               decoration: InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.email)),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             TextField(
//               controller: password,
//               decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.password)),
//               obscureText: true,
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   loginUser(context);
//
//                 },
//                 child: Text(
//                   "Login",
//                   style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontFamily:GoogleFonts.lato().fontFamily
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   foregroundColor: Colors.white,
//                 )
//             ),
//             SizedBox(height: 20),
//
//             // Login Text Button
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => RegistrationPage()),
//                 );
//               },
//               child: Text(
//                 'Registration',
//                 style: TextStyle(
//                   color: Colors.blue,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }