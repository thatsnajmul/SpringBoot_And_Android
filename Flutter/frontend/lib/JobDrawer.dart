import 'package:flutter/material.dart';
import 'package:frontend/UI/company/AddCompanyPage.dart';


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
            title: Text('View Job Application'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCompanyPage()),
              );
            },
          ),




        ],
      ),
    );
  }
}
