import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'model/User.dart'; // Make sure to import the User model

// Define enum for user roles
enum UserRole { ADMIN, EDITOR, USER }

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final User user = User(
    name: '',
    email: '',
    password: '',
    cell: '',
    address: '',
    gender: '',
    role: UserRole.USER.toString().split('.').last, // Default role as String
    image: '', // Placeholder for the image URL or path
    dob: '', // Placeholder for date of birth
    active: true, // Default active status
    isLock: false, // Default lock status
  );

  File? _image; // Variable to hold the picked image
  UserRole? _selectedRole; // Variable to hold the selected role

  // Method to pick an image from the gallery
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedFile != null) {
      // Check if the file is of the correct type (JPG or PNG)
      if (pickedFile.path.endsWith('.jpg') || pickedFile.path.endsWith('.jpeg') || pickedFile.path.endsWith('.png')) {
        setState(() {
          _image = File(pickedFile.path);
          user.image = _image!.path; // Update user image path
        });
      } else {
        // Handle unsupported file types
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a JPG or PNG image.')),
        );
      }
    } else {
      // Handle error when no image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected. Please try again.')),
      );
    }
  }

  Future<void> registerUser() async {
    var request = http.MultipartRequest('POST', Uri.parse('http://localhost:8080/api/register'));

    // Add fields to the request
    request.fields['name'] = user.name;
    request.fields['email'] = user.email;
    request.fields['password'] = user.password;
    request.fields['cell'] = user.cell;
    request.fields['address'] = user.address;
    request.fields['gender'] = user.gender;
    request.fields['role'] = user.role;
    request.fields['dob'] = user.dob;
    request.fields['active'] = user.active.toString();
    request.fields['isLock'] = user.isLock.toString();

    // Add image if picked
    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    }

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        // Successfully registered
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!')),
        );
      } else {
        // Registration failed
        final responseBody = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $responseBody')),
        );
      }
    } catch (e) {
      // Handle any exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => user.name = value,
                validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) => user.email = value,
                validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) => user.password = value,
                validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cell Number'),
                onChanged: (value) => user.cell = value,
                validator: (value) => value!.isEmpty ? 'Please enter your cell number' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                onChanged: (value) => user.address = value,
                validator: (value) => value!.isEmpty ? 'Please enter your address' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Gender'),
                items: <String>['Male', 'Female', 'Other']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => user.gender = value!,
                validator: (value) => value == null ? 'Please select your gender' : null,
              ),
              DropdownButtonFormField<UserRole>(
                decoration: InputDecoration(labelText: 'Role'),
                value: _selectedRole,
                items: UserRole.values.map((UserRole role) {
                  return DropdownMenuItem<UserRole>(
                    value: role,
                    child: Text(role.toString().split('.').last.toUpperCase()),
                  );
                }).toList(),
                onChanged: (UserRole? newValue) {
                  setState(() {
                    _selectedRole = newValue;
                    user.role = newValue.toString().split('.').last; // Update user role
                  });
                },
                validator: (value) => value == null ? 'Please select your role' : null,
              ),
              // Image selection button with border
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 2.0, color: Colors.blue),
                  ),
                ),
                child: TextButton(
                  onPressed: pickImage,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Pick Image (JPG or PNG)',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ),
              // Display selected image or message
              _image == null ? Text('No image selected.') : Image.file(_image!),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
                onChanged: (value) => user.dob = value,
                validator: (value) => value!.isEmpty ? 'Please enter your date of birth' : null,
              ),
              Row(
                children: [
                  Text('Active:'),
                  Checkbox(
                    value: user.active,
                    onChanged: (value) {
                      setState(() {
                        user.active = value!;
                      });
                    },
                  ),
                  Text('Locked:'),
                  Checkbox(
                    value: user.isLock,
                    onChanged: (value) {
                      setState(() {
                        user.isLock = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    registerUser();
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
