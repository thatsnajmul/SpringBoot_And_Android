import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:job/main.dart';
import 'AdminPage.dart'; // Replace with the actual path to your AdminPage
import 'EmployerPage.dart'; // Replace with the actual path to your EmployerPage

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = FlutterSecureStorage();
  String? userName;
  String? userEmail;
  String? userRole;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final name = await storage.read(key: 'user_name');
      final email = await storage.read(key: 'user_email');
      final role = await storage.read(key: 'user_role');

      // Debugging prints
      print('Fetched Data -> Name: $name, Email: $email, Role: $role');

      setState(() {
        userName = name ?? 'Name not available';
        userEmail = email ?? 'Email not available';
        userRole = role ?? 'Role not available';
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> logout(BuildContext context) async {
    // Clear all stored data
    await storage.deleteAll();

    // Navigate to LoginPage after clearing the data
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (userName != null) ...[
              Text('Name: $userName', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Email: $userEmail', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Role: $userRole', style: TextStyle(fontSize: 18)),
            ] else
              Center(child: CircularProgressIndicator()),

            SizedBox(height: 20),

            // Role-Based Buttons
            if (userRole == 'ADMIN')
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminPage()),
                  );
                },
                icon: Icon(Icons.admin_panel_settings),
                label: Text('Go to Admin Page'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            if (userRole == 'EMPLOYER')
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmployerPage()),
                  );
                },
                icon: Icon(Icons.business_center),
                label: Text('Go to Employer Page'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
              ),
            if (userRole == 'JOB_SEEKER')
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                icon: Icon(Icons.home),
                label: Text('Go to Home Screen'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange,
                ),
              ),

            Spacer(), // Push the button to the bottom

            // Logout Button
            ElevatedButton(
              onPressed: () => logout(context),
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:job/main.dart';
//
// import 'LoginReg/Login.dart'; // Replace with the actual path to your LoginPage class
//
// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   final storage = FlutterSecureStorage();
//   String? userName;
//   String? userEmail;
//   String? userRole;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }
//
//   Future<void> fetchUserData() async {
//     try {
//       final name = await storage.read(key: 'user_name');
//       final email = await storage.read(key: 'user_email');
//       final role = await storage.read(key: 'user_role');
//
//       // Debugging prints
//       print('Fetched Data -> Name: $name, Email: $email, Role: $role');
//
//       setState(() {
//         userName = name ?? 'Name not available';
//         userEmail = email ?? 'Email not available';
//         userRole = role ?? 'Role not available';
//       });
//     } catch (e) {
//       print('Error fetching user data: $e');
//     }
//   }
//
//   Future<void> logout(BuildContext context) async {
//     // Clear all stored data
//     await storage.deleteAll();
//
//     // Navigate to LoginPage after clearing the data
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => HomeScreen()),
//           (route) => false, // Remove all previous routes
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (userName != null) ...[
//               Text('Name: $userName', style: TextStyle(fontSize: 18)),
//               SizedBox(height: 10),
//               Text('Email: $userEmail', style: TextStyle(fontSize: 18)),
//               SizedBox(height: 10),
//               Text('Role: $userRole', style: TextStyle(fontSize: 18)),
//             ] else
//               Center(child: CircularProgressIndicator()),
//
//             Spacer(), // Push the button to the bottom
//
//             // Logout Button
//             ElevatedButton(
//               onPressed: () => logout(context),
//               child: Text(
//                 'Logout',
//                 style: TextStyle(fontSize: 16),
//               ),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.redAccent,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
