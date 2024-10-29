import 'package:flutter/material.dart';
import 'package:job/AdminViewJob.dart';
import 'package:job/RegisterScreen.dart';
import 'package:job/addJob.dart';
import 'ViewJob.dart';

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
        ],
      ),
    );
  }
}
