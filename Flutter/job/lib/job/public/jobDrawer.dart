import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:job/LoginReg/Login.dart';
import 'package:job/Profile.dart';
import 'package:job/company/admin/AdminViewCompany.dart';
import 'package:job/company/public/AddCompany.dart';
import 'package:job/company/public/CarouselCompanyView.dart';
import 'package:job/company/public/ViewCompany.dart';
import 'package:job/job-application/admin/AdminViewJobApplication.dart';
import 'package:job/job-application/public/ViewJobApplication.dart';
import 'package:job/job/admin/AdminViewJob.dart';
import 'package:job/LoginReg/RegisterScreen.dart';
import 'package:job/job/public/addJob.dart';
import 'package:job/main.dart';

class JobDrawer extends StatefulWidget {
  @override
  _JobDrawerState createState() => _JobDrawerState();
}

class _JobDrawerState extends State<JobDrawer> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  String? userName;
  String? userEmail;
  String? userRole;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final name = await storage.read(key: 'user_name');
    final email = await storage.read(key: 'user_email');
    final role = await storage.read(key: 'user_role');
    setState(() {
      userName = name ?? 'User Name';
      userEmail = email ?? 'user@example.com';
      userRole = role ?? 'Role';
    });
  }

  Future<void> logout(BuildContext context) async {
    await storage.deleteAll();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Profile Section
          UserAccountsDrawerHeader(
            accountName: Text(
              userName ?? 'Loading...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(userEmail ?? 'Loading...'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.blueAccent,
                size: 40,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),

          // Role-Based Navigation
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Common Items
                _buildDrawerItem(
                  context,
                  'Profile',
                  Icons.person,
                  ProfilePage(),
                ),
                if (userRole == 'ADMIN') ...[
                  _buildDrawerItem(
                    context,
                    'Admin Jobs',
                    Icons.work,
                    AdminViewJob(),
                  ),
                  _buildDrawerItem(
                    context,
                    'Admin Applications',
                    Icons.admin_panel_settings,
                    AdminViewJobApplications(),
                  ),
                  _buildDrawerItem(
                    context,
                    'Admin Companies',
                    Icons.business_center,
                    AdminViewCompany(),
                  ),
                ],
                if (userRole == 'EMPLOYER') ...[
                  _buildDrawerItem(
                    context,
                    'Post Job',
                    Icons.post_add,
                    AddJob(),
                  ),
                  _buildDrawerItem(
                    context,
                    'View Applications',
                    Icons.library_books,
                    ViewJobApplication(),
                  ),
                ],
                if (userRole == 'JOB_SEEKER') ...[
                  _buildDrawerItem(
                    context,
                    'View Jobs',
                    Icons.search,
                    HomeScreen(),
                  ),
                  _buildDrawerItem(
                    context,
                    'Apply Jobs',
                    Icons.send,
                    ViewJobApplication(),
                  ),
                ],
              ],
            ),
          ),

          // Logout Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () => logout(context),
              icon: Icon(Icons.logout),
              label: Text('Logout'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, IconData icon, Widget destination) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:job/LoginReg/Login.dart';
// import 'package:job/company/admin/AdminViewCompany.dart';
// import 'package:job/company/public/AddCompany.dart';
// import 'package:job/company/public/CarouselCompanyView.dart';
// import 'package:job/company/public/ViewCompany.dart';
// import 'package:job/job-application/admin/AdminViewJobApplication.dart';
// import 'package:job/job-application/public/ViewJobApplication.dart';
// import 'package:job/job/admin/AdminViewJob.dart';
// import 'package:job/LoginReg/RegisterScreen.dart';
// import 'package:job/job/public/addJob.dart';
//
// class JobDrawer extends StatelessWidget {
//   final double minimumPadding = 5.0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add margin to left and right
//         child: Column(
//           children: [
//             // Drawer Header Section
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.work,
//                     color: Colors.white,
//                     size: 50,
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Job Search',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // GridView for Drawer Items (2 blocks per row with margins)
//             Expanded(
//               child: GridView.count(
//                 crossAxisCount: 2, // 2 columns in the grid
//                 crossAxisSpacing: 10.0, // Horizontal spacing between grid items
//                 mainAxisSpacing: 10.0, // Vertical spacing between grid items
//                 children: [
//                   _buildDrawerItem(
//                     context,
//                     'Add Job',
//                     Icons.add,
//                     AddJob(),
//                   ),
//                   _buildDrawerItem(
//                     context,
//                     'View Job',
//                     Icons.visibility,
//                     AdminViewJob(),
//                   ),
//                   _buildDrawerItem(
//                     context,
//                     'For Registration',
//                     Icons.app_registration,
//                    RegistrationPage(),
//                   ),
//                   _buildDrawerItem(
//                     context,
//                     'For Login',
//                     Icons.login,
//                     LoginPage(),
//                   ),
//                   _buildDrawerItem(
//                     context,
//                     'View Job Application',
//                     Icons.library_books,
//                     ViewJobApplication(),
//                   ),
//                   _buildDrawerItem(
//                     context,
//                     'Admin View Job Application',
//                     Icons.admin_panel_settings,
//                     AdminViewJobApplications(),
//                   ),
//                   _buildDrawerItem(
//                     context,
//                     'Add Company',
//                     Icons.business,
//                     AddCompany(),
//                   ),
//                   _buildDrawerItem(
//                     context,
//                     'View Company',
//                     Icons.business_outlined,
//                     ViewCompany(),
//                   ),
//                   _buildDrawerItem(
//                     context,
//                     'Admin View Company',
//                     Icons.business_center,
//                     AdminViewCompany(),
//                   ),
//                   _buildDrawerItem(
//                     context,
//                     'Carousel Company View',
//                     Icons.view_carousel,
//                     CarouselCompanyView(),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Helper method to create Grid items for each navigation option
//   Widget _buildDrawerItem(BuildContext context, String title, IconData icon, Widget destination) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.pop(context); // Close the drawer
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => destination),
//         );
//       },
//       child: Card(
//         elevation: 5.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15.0),
//         ),
//         child: Container(
//           padding: EdgeInsets.all(10.0),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15.0),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 color: Colors.blue,
//                 size: 40.0,
//               ),
//               SizedBox(height: 10),
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14.0,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
