import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Company {
  final String companyName;
  final String companyEmail;
  final String companyPhone;
  final String companyAddress;
  final String companyDetails;
  final String companyImage;
  final String employeeSize;

  Company({
    required this.companyName,
    required this.companyEmail,
    required this.companyPhone,
    required this.companyAddress,
    required this.companyDetails,
    required this.companyImage,
    required this.employeeSize,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyName: json['companyName'] ?? '',
      companyEmail: json['companyEmail'] ?? '',
      companyPhone: json['companyPhone'] ?? '',
      companyAddress: json['companyAddress'] ?? '',
      companyDetails: json['companyDetails'] ?? '',
      companyImage: json['companyImage']?.toString() ?? '',
      employeeSize: (json['employeeSize'] is int
          ? json['employeeSize'].toString()
          : json['employeeSize'] ?? ''),
    );
  }
}

class UpdateCompany extends StatefulWidget {
  final String companyId;
  UpdateCompany({required this.companyId});

  @override
  _UpdateCompanyState createState() => _UpdateCompanyState();
}

class _UpdateCompanyState extends State<UpdateCompany> {
  final double minimumPadding = 8.0;
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyDetailsController = TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();
  final TextEditingController companyPhoneController = TextEditingController();
  final TextEditingController companyAddressController = TextEditingController();
  final TextEditingController employeeSizeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Fetch company details by ID
  Future<void> fetchCompanyDetails() async {
    setState(() {
      _isLoading = true; // Show loading indicator while fetching data
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/companies/get-by-id/${widget.companyId}'),
      );

      // Debugging: Check the response status and body
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> company = json.decode(response.body);

        // Debugging: Check the decoded company data
        print('Company Data: $company');

        setState(() {
          companyNameController.text = company['companyName'] ?? '';
          companyDetailsController.text = company['companyDetails'] ?? '';
          companyEmailController.text = company['companyEmail'] ?? '';
          companyPhoneController.text = company['companyPhone'] ?? '';
          companyAddressController.text = company['companyAddress'] ?? '';
          employeeSizeController.text = company['employeeSize'] != null
              ? company['employeeSize'].toString()
              : ''; // Handle null values safely
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch company details')),
        );
      }
    } catch (e) {
      // Debugging: Print any error caught during the fetch
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator after fetching
      });
    }
  }

  // Update company details
  Future<void> _updateCompany() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true; // Show loading indicator while updating data
      });

      final updatedCompanyData = {
        'companyName': companyNameController.text,
        'companyDetails': companyDetailsController.text,
        'companyEmail': companyEmailController.text,
        'companyPhone': companyPhoneController.text,
        'companyAddress': companyAddressController.text,
        'employeeSize': int.tryParse(employeeSizeController.text) ?? 0, // Handle empty or invalid input gracefully
      };

      try {
        final response = await http.put(
          Uri.parse('http://localhost:8080/api/companies/update/${widget.companyId}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(updatedCompanyData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Company updated successfully!')),
          );
          Navigator.pop(context); // Go back on successful update
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update company')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator after update
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCompanyDetails(); // Fetch company details on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Update Company', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.all(minimumPadding * 2),
        child: _isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading spinner while fetching/updating
            : Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              buildTextField(
                controller: companyNameController,
                label: 'Company Name',
                hint: 'Enter company name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter company name';
                  }
                  return null;
                },
              ),
              buildTextField(
                controller: companyDetailsController,
                label: 'Company Details',
                hint: 'Enter company details',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter company details';
                  }
                  return null;
                },
              ),
              buildTextField(
                controller: companyEmailController,
                label: 'Company Email',
                hint: 'Enter company email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter company email';
                  } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              buildTextField(
                controller: companyPhoneController,
                label: 'Company Phone',
                hint: 'Enter company phone',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter company phone';
                  } else if (!RegExp(r"^[0-9]{10}$").hasMatch(value)) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              buildTextField(
                controller: companyAddressController,
                label: 'Company Address',
                hint: 'Enter company address',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter company address';
                  }
                  return null;
                },
              ),
              buildTextField(
                controller: employeeSizeController,
                label: 'Employee Size',
                hint: 'Enter number of employees',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter employee size';
                  } else if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: minimumPadding * 2),
              ElevatedButton(
                onPressed: _updateCompany,
                child: Text('Update Company'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepPurple, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: minimumPadding, bottom: minimumPadding),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: Colors.deepPurple),
          hintStyle: TextStyle(color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(8.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}
