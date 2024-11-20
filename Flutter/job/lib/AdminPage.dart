import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Admin!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Action for managing users
                print('Manage Users Clicked');
              },
              child: Text('Manage Users'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Action for managing jobs or other features
                print('Manage Jobs Clicked');
              },
              child: Text('Manage Jobs'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Action for viewing site analytics
                print('View Analytics Clicked');
              },
              child: Text('View Analytics'),
            ),
          ],
        ),
      ),
    );
  }
}
