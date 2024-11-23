import 'package:flutter/material.dart';
import 'package:job/company/admin/AdminViewCompany.dart';
import 'package:job/company/admin/CompanyViewByCurrentUser.dart';
import 'package:job/job-application/public/ViewJobApplication.dart';
import 'package:job/job/public/addJob.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddJob()),
                );
              },
              child: Text('Add Job'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewJobApplication()),
                );
              },
              child: Text('View Job Application'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompanyViewByCurrentUser()),
                );
              },
              child: Text('Manage Company Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
