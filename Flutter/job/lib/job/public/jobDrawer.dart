import 'package:flutter/material.dart';
import 'package:job/company/admin/AdminViewCompany.dart';
import 'package:job/company/public/AddCompany.dart';
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
      child: ListView(
        padding: EdgeInsets.only(top: minimumPadding, bottom: minimumPadding),
        children: <Widget>[
          DrawerHeader(
            child: Text('Job Search'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Add Job'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddJob()),
              );
            },
          ),
          ListTile(
            title: Text('View Job'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminViewJob()),
              );
            },
          ),
          ListTile(
            title: Text('For Registration'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
          ),
          ListTile(
            title: Text('For Login'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          ListTile(
            title: Text('View Job Application'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewJobApplication(jobTitle: '',)),
              );
            },
          ),
          ListTile(
            title: Text('Admin View Job Application'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminViewJobApplications(jobTitle: '')),
              );
            },
          ),
          ListTile(
            title: Text('Add Company'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCompany()),
              );
            },
          ),
          ListTile(
            title: Text('View Company'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewCompany()),
              );
            },
          ),
          ListTile(
            title: Text('Admin View Company'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminViewCompany()),
              );
            },
          ),

        ],
      ),
    );
  }
}
