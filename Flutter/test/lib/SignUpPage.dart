import 'package:flutter/material.dart';
import 'package:fluttertest/LoginPage.dart';
import 'package:intl/intl.dart'; // For formatting date

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Page'),
      ),
      body: SignUpForm(),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _cellController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _gender; // Variable to hold the selected gender

  // Function to open the date picker and set the selected date
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text(
              'Sign Up',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),

            // Name field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Date of Birth field with Date Picker
            TextFormField(
              controller: _dobController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => _selectDate(context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your date of birth';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // City field
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your city';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Location field
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your location';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Cell Number field
            TextFormField(
              controller: _cellController,
              decoration: InputDecoration(
                labelText: 'Cell Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your cell number';
                }
                if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                  return 'Please enter a valid cell number';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Address field
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.home),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Gender field with Radio buttons and icons
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gender:', style: TextStyle(fontSize: 16)),
                  Wrap(
                    spacing: 16.0, // Space between radio buttons
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Male',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          ),
                          Icon(Icons.male),
                          Text('Male'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Female',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          ),
                          Icon(Icons.female),
                          Text('Female'),

                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Other',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          ),
                          Icon(Icons.transgender),
                          Text('Other'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Email field
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Password field
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Confirm Password field
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Process sign up
                  print('Name: ${_nameController.text}');
                  print('Date of Birth: ${_dobController.text}');
                  print('City: ${_cityController.text}');
                  print('Location: ${_locationController.text}');
                  print('Cell: ${_cellController.text}');
                  print('Address: ${_addressController.text}');
                  print('Gender: $_gender');
                  print('Email: ${_emailController.text}');
                  print('Password: ${_passwordController.text}');
                  // TODO: Implement sign up functionality
                }
              },
              child: Text('Sign Up'),
            ),
            SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                // Navigate to Login Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(
                'Already have an account? Login',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
