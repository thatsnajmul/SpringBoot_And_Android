import 'package:flutter/material.dart';
import 'package:job/company/admin/AdminViewCompany.dart';
import 'package:job/company/public/AddCompany.dart';
import 'package:job/company/public/CarouselCompanyView.dart';
import 'package:job/company/public/ViewCompany.dart';
import 'package:job/job-application/admin/AdminViewJobApplication.dart';
import 'package:job/job-application/public/ViewJobApplication.dart';
import 'package:job/job/admin/AdminViewJob.dart';
import 'package:job/LoginReg/RegisterScreen.dart';
import 'package:job/job/public/addJob.dart';

class JobDrawer extends StatelessWidget {
  final double minimumPadding = 5.0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add margin to left and right
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

            // GridView for Drawer Items (2 blocks per row with margins)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // 2 columns in the grid
                crossAxisSpacing: 10.0, // Horizontal spacing between grid items
                mainAxisSpacing: 10.0, // Vertical spacing between grid items
                children: [
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
                    AdminViewJob(),
                  ),
                  _buildDrawerItem(
                    context,
                    'For Registration',
                    Icons.app_registration,
                    RegisterScreen(),
                  ),
                  _buildDrawerItem(
                    context,
                    'For Login',
                    Icons.login,
                    LoginScreen(),
                  ),
                  _buildDrawerItem(
                    context,
                    'View Job Application',
                    Icons.library_books,
                    ViewJobApplication(),
                  ),
                  _buildDrawerItem(
                    context,
                    'Admin View Job Application',
                    Icons.admin_panel_settings,
                    AdminViewJobApplications(),
                  ),
                  _buildDrawerItem(
                    context,
                    'Add Company',
                    Icons.business,
                    AddCompany(),
                  ),
                  _buildDrawerItem(
                    context,
                    'View Company',
                    Icons.business_outlined,
                    ViewCompany(),
                  ),
                  _buildDrawerItem(
                    context,
                    'Admin View Company',
                    Icons.business_center,
                    AdminViewCompany(),
                  ),
                  _buildDrawerItem(
                    context,
                    'Carosel Company View',
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


