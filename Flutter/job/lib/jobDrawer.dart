import 'package:flutter/material.dart';
import 'package:job/AdminViewJob.dart';
import 'package:job/addJob.dart';
import 'ViewJob.dart';

class JobDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JobDrawerState();
  }
}

class JobDrawerState extends State<JobDrawer> {
  final double minimumPadding = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job'),
      ),
      body: ViewJob(), // Set ViewJob as the initial body content
      drawer: Drawer(
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddJob()));
              },
            ),
            ListTile(
              title: Text('View Job'),
              onTap: () {
                // Navigates to ViewJob page, if you want a separate page instance
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminViewJob()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
