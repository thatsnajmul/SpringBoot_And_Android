import 'package:flutter/material.dart';
import 'package:job/Profile.dart';
import 'package:job/company/public/ViewCompany.dart';
import 'package:job/job/public/ViewJob.dart';
import 'package:job/job/public/addJob.dart';
import 'LoginReg/Login.dart';
import 'job/public/jobDrawer.dart'; // Import the JobDrawer widget
import 'LoginReg/RegisterScreen.dart'; // Import the RegisterScreen widget


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // Set HomeScreen as the home widget
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    ViewJob(), // View Jobs
    ViewCompany(), // Add Job
    ProfilePage(
        name: 'name',
        email: 'email',
        profileImageUrl: 'https://nmhislam.wordpress.com/wp-content/uploads/2016/12/15129046_1776258662641056_826858525416318744_o.jpg')
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Register()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.app_registration),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Register()),
              );
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'View Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'View Companies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      drawer: JobDrawer(), // Ensure JobDrawer is implemented correctly
    );
  }
}
