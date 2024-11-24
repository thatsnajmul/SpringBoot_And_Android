import 'package:flutter/material.dart';
import 'package:job/job/admin/AdminViewJob.dart';
import 'package:job/job-application/admin/AdminViewJobApplication.dart';
import 'package:job/company/admin/AdminViewCompany.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Admin!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Manage all administrative tasks from this dashboard.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Functional Buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildAdminFeature(
                    context,
                    title: 'Manage Jobs',
                    icon: Icons.work,
                    destination: AdminViewJob(),
                  ),
                  _buildAdminFeature(
                    context,
                    title: 'View Applications',
                    icon: Icons.assignment,
                    destination: AdminViewJobApplications(),
                  ),
                  _buildAdminFeature(
                    context,
                    title: 'Manage Companies',
                    icon: Icons.business_center,
                    destination: AdminViewCompany(),
                  ),
                  _buildAdminFeature(
                    context,
                    title: 'Settings',
                    icon: Icons.settings,
                    destination: PlaceholderWidget('Settings Page'),
                  ),
                  _buildAdminFeature(
                    context,
                    title: 'Reports',
                    icon: Icons.analytics,
                    destination: PlaceholderWidget('Reports Page'),
                  ),
                  _buildAdminFeature(
                    context,
                    title: 'User Management',
                    icon: Icons.people,
                    destination: PlaceholderWidget('User Management Page'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminFeature(BuildContext context,
      {required String title, required IconData icon, required Widget destination}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blueAccent, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String title;
  PlaceholderWidget(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
