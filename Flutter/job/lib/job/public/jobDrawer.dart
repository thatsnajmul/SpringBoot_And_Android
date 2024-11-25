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
                    'Add Job',
                    Icons.add,
                    AddJob(),
                  ),
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
                    'View Applications',
                    Icons.admin_panel_settings,
                    ViewJobApplication(),
                  ),
                  _buildDrawerItem(
                    context,
                    'Add Companies',
                    Icons.add,
                    AddCompany(),
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
