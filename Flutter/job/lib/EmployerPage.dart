import 'package:flutter/material.dart';

class EmployerPage extends StatefulWidget {
  @override
  _EmployerPageState createState() => _EmployerPageState();
}

class _EmployerPageState extends State<EmployerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employer Page'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Employer!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Job Posting Page
                print('Post Job Clicked');
              },
              child: Text('Post a Job'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Job Applications Page
                print('View Applications Clicked');
              },
              child: Text('View Applications'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Company Profile Management Page
                print('Manage Company Profile Clicked');
              },
              child: Text('Manage Company Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
