import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job/LoginReg/Login.dart';
import 'package:job/company/admin/AdminViewCompany.dart';
import 'package:job/company/public/AddCompany.dart';
import 'package:job/company/public/CarouselCompanyView.dart';
import 'package:job/company/public/ViewCompany.dart';
import 'package:job/job-application/admin/AdminViewJobApplication.dart';
import 'package:job/job-application/public/ViewJobApplication.dart';
import 'package:job/job/admin/AdminViewJob.dart';
import 'package:job/LoginReg/RegisterScreen.dart';
import 'package:job/job/public/addJob.dart';

class Adminpage extends StatefulWidget {
  @override
  _AdminpageState createState() => _AdminpageState();
}

class _AdminpageState extends State<Adminpage> {
  String? role; // Track the user's role

  @override
  void initState() {
    super.initState();
    _fetchUserRole(); // Fetch role from local storage
  }

  // Fetch user role from SharedPreferences
  Future<void> _fetchUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role'); // e.g., "admin" or "user"
    });
    print("User role: $role"); // Debugging
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Drawer Header Section
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.work,
                    color: Colors.white,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Job Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Drawer Items Section
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: [

                  Text("For Job"),
                  // Common Items for All Users
                  _buildDrawerItem(
                    context,
                    'Add Job',
                    Icons.add,
                    AddJob(),
                  ),
                  _buildDrawerItem(
                    context,
                    'View Job',
                    Icons.visibility,
                    AdminViewJob(), // Or a common ViewJob if needed
                  ),

                  Text("For Job Application"),
                  _buildDrawerItem(
                    context,
                    'View',
                    Icons.library_books,
                    ViewJobApplication(),
                  ),
                  // Admin-Only Items
                  _buildDrawerItem(
                    context,
                    'Update & Delete',
                    Icons.admin_panel_settings,
                    AdminViewJobApplications(),
                  ),

                  Text("For Company"),
                  _buildDrawerItem(
                    context,
                    'Add',
                    Icons.business,
                    AddCompany(),
                  ),
                  _buildDrawerItem(
                    context,
                    'View',
                    Icons.business_outlined,
                    ViewCompany(),
                  ),
                  _buildDrawerItem(
                    context,
                    'Update & Delete',
                    Icons.business_outlined,
                    AdminViewCompany(),
                  ),
                  _buildDrawerItem(
                    context,
                    'Carousel Company View',
                    Icons.view_carousel,
                    CarouselCompanyView(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create Grid items for each navigation option
  Widget _buildDrawerItem(BuildContext context, String title, IconData icon, Widget destination) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Close the drawer
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.blue,
                size: 40.0,
              ),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
