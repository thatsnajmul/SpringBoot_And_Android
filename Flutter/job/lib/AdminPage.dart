import 'package:flutter/material.dart';
import 'package:job/company/admin/AdminViewCompany.dart';
import 'package:job/company/public/AddCompany.dart';
import 'package:job/company/public/CarouselCompanyView.dart';
import 'package:job/company/public/ViewCompany.dart';
import 'package:job/job-application/admin/AdminViewJobApplication.dart';
import 'package:job/job-application/public/ViewJobApplication.dart';
import 'package:job/job/admin/AdminViewJob.dart';
import 'package:job/job/public/addJob.dart';

class Adminpage extends StatefulWidget {
  @override
  _AdminpageState createState() => _AdminpageState();
}

class _AdminpageState extends State<Adminpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Title
            Text(
              'Admin Actions - Jobs',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 16), // Spacing between title and grid

            // First Grid - Jobs related actions
            Expanded(
              flex: 1,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 4 items per row
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 1.2, // Aspect ratio of the button items
                ),
                itemCount: 4, // Only 4 items for Jobs related actions
                itemBuilder: (context, index) {
                  return _buildDrawerItem(
                    context,
                    _getItemTitle(index),
                    _getItemIcon(index),
                    _getItemDestination(index),
                  );
                },
              ),
            ),
            SizedBox(height: 20), // Space between the grids

            // Second Title
            Text(
              'Admin Actions - Companies',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 16), // Spacing between title and grid

            // Second Grid - Company related actions
            Expanded(
              flex: 1,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 4 items per row
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 1.2, // Aspect ratio of the button items
                ),
                itemCount: 4, // Only 4 items for Company related actions
                itemBuilder: (context, index) {
                  return _buildDrawerItem(
                    context,
                    _getItemTitle(index + 4), // Skipping the first 4 for the second section
                    _getItemIcon(index + 4), // Skipping the first 4 for the second section
                    _getItemDestination(index + 4), // Skipping the first 4 for the second section
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get the title for each item based on the index
  String _getItemTitle(int index) {
    switch (index) {
      case 0:
        return 'Add Job';
      case 1:
        return 'View Job';
      case 2:
        return 'View Job Application';
      case 3:
        return 'Add Company';
      case 4:
        return 'View Company';
      case 5:
        return 'Manage Job Applications';
      case 6:
        return 'Manage Companies';
      case 7:
        return 'Carousel View';
      default:
        return '';
    }
  }

  // Helper method to get the icon for each item based on the index
  IconData _getItemIcon(int index) {
    switch (index) {
      case 0:
        return Icons.add;
      case 1:
        return Icons.visibility;
      case 2:
        return Icons.library_books;
      case 3:
        return Icons.business;
      case 4:
        return Icons.business_outlined;
      case 5:
        return Icons.admin_panel_settings;
      case 6:
        return Icons.business_outlined;
      case 7:
        return Icons.view_carousel;
      default:
        return Icons.help;
    }
  }

  // Helper method to get the destination widget for each item based on the index
  Widget _getItemDestination(int index) {
    switch (index) {
      case 0:
        return AddJob();
      case 1:
        return AdminViewJob();
      case 2:
        return ViewJobApplication();
      case 3:
        return AddCompany();
      case 4:
        return ViewCompany();
      case 5:
        return AdminViewJobApplications();
      case 6:
        return AdminViewCompany();
      case 7:
        return CarouselCompanyView();
      default:
        return AddJob(); // Default fallback
    }
  }

  // Helper method to create each grid item
  Widget _buildDrawerItem(BuildContext context, String title, IconData icon, Widget destination) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.blueAccent,
                size: 40.0,
              ),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
