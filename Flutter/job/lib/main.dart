import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _isUserLoggedIn = false; // Variable to track if user is logged in
  bool _hasRole = false; // Variable to check if role is present (indicating logged in)
  String? _userRole; // Variable to store the role of the user

  // Initialize the list of widget options
  final List<Widget> _widgetOptions = <Widget>[
    ViewJob(), // View Jobs
    ViewCompany(), // View Companies
    // ProfilePage() // Profile
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check if the user is logged in and has a role
  }

  // Function to check login status and role from local storage
  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // Retrieve login status
    String? role = prefs.getString('role'); // Retrieve user role

    setState(() {
      _isUserLoggedIn = isLoggedIn; // Update login state
      _hasRole = role != null && role.isNotEmpty; // Update role presence state
      _userRole = role; // Store the user's role
    });
  }

  // Function to log out the user
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false); // Set login status to false
    prefs.remove('role'); // Remove role
    setState(() {
      _isUserLoggedIn = false; // Update UI after logout
      _hasRole = false; // Role no longer exists
      _userRole = null; // Clear role information
    });
  }

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
          // Conditionally show Profile button if user is logged in and has a role
          if (_isUserLoggedIn && _hasRole)
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          // Conditionally show Login button if user is not logged in or has no role
          if (!_isUserLoggedIn || !_hasRole)
            IconButton(
              icon: Icon(Icons.login),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          // Conditionally show Register button if user is not logged in or has no role
          if (!_isUserLoggedIn || !_hasRole)
            IconButton(
              icon: Icon(Icons.app_registration),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
            ),
          // Conditionally show Logout button if user is logged in and has a role
          if (_isUserLoggedIn && _hasRole)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
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
            icon: Icon(Icons.business),
            label: 'View Companies',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'Profile',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      drawer: JobDrawer(), // Ensure JobDrawer is implemented correctly
    );
  }
}
