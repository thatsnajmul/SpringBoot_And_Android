import 'package:flutter/material.dart';
import 'package:job/addJob.dart';

import 'ViewJob.dart';

class jobDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JobDrawerState();
  }
}

class JobDrawerState extends State<jobDrawer> {
  final double minimumPadding = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job'),
      ),
      body: Center(child: Text('Welcome to Job Search')),
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
              title: Text('Add Job'), // Add the title you want
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddJob()));
              },
            ),
            ListTile(
              title: Text('View Job'), // Add the title you want
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewJob()));
              },
            ),
            // Add more ListTile widgets as needed
          ],
        ),
      ),
    );
  }
}
