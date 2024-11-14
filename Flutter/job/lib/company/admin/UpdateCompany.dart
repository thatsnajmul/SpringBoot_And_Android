import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UpdateCompany extends StatefulWidget {
  final String companyId;

  UpdateCompany({required this.companyId});

  @override
  _UpdateCompanyState createState() => _UpdateCompanyState();
}

class _UpdateCompanyState extends State<UpdateCompany> {
  final double minimumPadding = 5.0;
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();
  final TextEditingController companyPhoneController = TextEditingController();
  final TextEditingController companyAddressController = TextEditingController();
  final TextEditingController companyDetailsController = TextEditingController();
  final TextEditingController employeeSizeController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController(); // Image URL controller

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? _selectedImage; // To store selected image locally

  @override
  void initState() {
    super.initState();
    _fetchCompanyDetails(); // Fetch company details when screen loads
  }

  // Fetch company details from API
  Future<void> _fetchCompanyDetails() async {
    setState(() => _isLoading = true);
    try {
      // Update localhost URL for devices/emulators
      final response = await http.get(Uri.parse('http://localhost:8080/api/companies/get-by-id/${widget.companyId}'));

      if (response.statusCode == 200) {
        final company = json.decode(response.body);
        setState(() {
          companyNameController.text = company['companyName'] ?? '';
          companyEmailController.text = company['companyEmail'] ?? '';
          companyPhoneController.text = company['companyPhone'] ?? '';
          companyAddressController.text = company['companyAddress'] ?? '';
          companyDetailsController.text = company['companyDetails'] ?? '';
          employeeSizeController.text = company['employeeSize']?.toString() ?? '';
          // imageUrlController.text = company['companyImage'] ?? '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch company details')));
        print('Error: Failed to load company details with status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      print('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Handle image selection
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        imageUrlController.text = pickedFile.path; // Store image path in the controller
      });
    }
  }

  // Update company details
  Future<void> _updateCompany() async {
    if (!_formKey.currentState!.validate()) return; // Validate form before submitting

    setState(() => _isLoading = true);

    // Create the company update request
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8080/api/companies/update/${widget.companyId}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'companyName': companyNameController.text,
          'companyEmail': companyEmailController.text,
          'companyPhone': companyPhoneController.text,
          'companyAddress': companyAddressController.text,
          'companyDetails': companyDetailsController.text,
          'employeeSize': employeeSizeController.text,
          'companyImage': imageUrlController.text, // Assuming you want to store the image URL or path
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Company updated successfully!')));
        Navigator.pop(context); // Go back after update
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update company.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Company')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(minimumPadding),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: companyNameController,
                  decoration: InputDecoration(labelText: 'Company Name'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Company name is required';
                    return null;
                  },
                ),
                TextFormField(
                  controller: companyEmailController,
                  decoration: InputDecoration(labelText: 'Company Email'),
                  validator: (value) {
                    if (value!.isEmpty || !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return 'Enter a valid email';
                    return null;
                  },
                ),
                TextFormField(
                  controller: companyPhoneController,
                  decoration: InputDecoration(labelText: 'Company Phone'),
                ),
                TextFormField(
                  controller: companyAddressController,
                  decoration: InputDecoration(labelText: 'Company Address'),
                ),
                TextFormField(
                  controller: companyDetailsController,
                  decoration: InputDecoration(labelText: 'Company Details'),
                ),
                TextFormField(
                  controller: employeeSizeController,
                  decoration: InputDecoration(labelText: 'Employee Size'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image),
                      tooltip: 'Pick Image',
                    ),
                    _selectedImage != null
                        ? Image.file(_selectedImage!, width: 100, height: 100, fit: BoxFit.cover)
                        : Text('No image selected'),
                  ],
                ),
                ElevatedButton(
                  onPressed: _updateCompany,
                  child: Text('Update Company'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
