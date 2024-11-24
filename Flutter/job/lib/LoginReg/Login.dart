import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:job/Profile.dart';
import 'package:job/main.dart';
import '../AdminPage.dart';
import '../EmployerPage.dart';
import '../Service/AuthService.dart';
import '../job/public/jobDrawer.dart';
import '../LoginReg/RegisterScreen.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final storage = FlutterSecureStorage();
  final AuthService authService = AuthService();

  Future<void> loginUser(BuildContext context) async {
    try {
      // Attempt login
      final isLoggedIn = await authService.login('', email.text, password.text);

      if (isLoggedIn) {
        // Retrieve role from shared preferences
        final String? role = await authService.getUserRole();

        // Save user details in secure storage
        await storage.write(key: 'user_role', value: role);
        await storage.write(key: 'user_email', value: email.text);

        // Navigate to appropriate screen based on role
        if (role == 'ADMIN') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        } else if (role == 'EMPLOYER') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        } else if (role == 'JOB_SEEKER') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          throw Exception('Unknown role');
        }
      } else {
        _showErrorDialog(context, 'Login failed. Please check your credentials.');
      }
    } catch (error) {
      _showErrorDialog(context, 'An error occurred during login: $error');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // This will take the user back to the previous screen
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
                prefixIcon: Icon(Icons.password),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => loginUser(context),
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
// import 'package:job/main.dart';
// import '../AdminPage.dart';
// import '../EmployerPage.dart';
// import '../Service/AuthService.dart';
// import '../job/public/jobDrawer.dart';
// import '../LoginReg/RegisterScreen.dart';
//
// class LoginPage extends StatelessWidget {
//   final TextEditingController email = TextEditingController();
//   final TextEditingController password = TextEditingController();
//   final storage = FlutterSecureStorage();
//   final AuthService authService = AuthService();
//
//   Future<void> loginUser(BuildContext context) async {
//     try {
//       // Attempt login
//       final isLoggedIn = await authService.login('', email.text, password.text);
//
//       if (isLoggedIn) {
//         // Retrieve role from shared preferences
//         final String? role = await authService.getUserRole();
//
//         // Save user details in secure storage
//         await storage.write(key: 'user_role', value: role);
//         await storage.write(key: 'user_email', value: email.text);
//
//         // Navigate to appropriate screen based on role
//         if (role == 'ADMIN') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => Adminpage()),
//           );
//         } else if (role == 'EMPLOYER') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => EmployerPage()),
//           );
//         } else if (role == 'JOB_SEEKER') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => HomeScreen()),
//           );
//         } else {
//           throw Exception('Unknown role');
//         }
//       } else {
//         _showErrorDialog(context, 'Login failed. Please check your credentials.');
//       }
//     } catch (error) {
//       _showErrorDialog(context, 'An error occurred during login: $error');
//     }
//   }
//
//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: email,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.email),
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: password,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.password),
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => loginUser(context),
//               child: Text(
//                 "Login",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontFamily: GoogleFonts.lato().fontFamily,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blueAccent,
//                 foregroundColor: Colors.white,
//               ),
//             ),
//             SizedBox(height: 20),
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
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }