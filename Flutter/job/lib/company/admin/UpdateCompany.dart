import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateCompany extends StatefulWidget {
  final String companyId;
  UpdateCompany({required this.companyId});

  @override
  _UpdateCompanyState createState() => _UpdateCompanyState();
}

class _UpdateCompanyState extends State<UpdateCompany> {
  final double minimumPadding = 5.0;
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
      _isLoading = true;  // Show loading indicator while fetching data
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/companies/get-by-id/${widget.companyId}'),
      );

      if (response.statusCode == 200) {
        final company = json.decode(response.body);

        setState(() {
          companyNameController.text = company['companyName'] ?? '';
          companyDetailsController.text = company['companyDetails'] ?? '';
          companyEmailController.text = company['companyEmail'] ?? '';
          companyPhoneController.text = company['companyPhone'] ?? '';
          companyAddressController.text = company['companyAddress'] ?? '';
          employeeSizeController.text = company['employeeSize']?.toString() ?? '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch company details')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;  // Hide loading indicator after fetching
      });
    }
  }

  // Update company details
  Future<void> _updateCompany() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true;  // Show loading indicator while updating data
      });

      final updatedCompanyData = {
        'companyName': companyNameController.text,
        'companyDetails': companyDetailsController.text,
        'companyEmail': companyEmailController.text,
        'companyPhone': companyPhoneController.text,
        'companyAddress': companyAddressController.text,
        'employeeSize': int.tryParse(employeeSizeController.text) ?? 0,
      };

      try {
        final response = await http.put(
          Uri.parse('http://192.168.88.243:8080/api/companies/update/${widget.companyId}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(updatedCompanyData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Company updated successfully!')));
          Navigator.pop(context);  // Go back on successful update
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update company')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() {
          _isLoading = false;  // Hide loading indicator after update
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCompanyDetails();  // Fetch company details on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Company')),
      body: Padding(
        padding: EdgeInsets.all(minimumPadding * 2),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())  // Show loading spinner while fetching/updating
            : Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              buildTextField(
                controller: companyNameController,
                label: 'Company Name',
                hint: 'Enter company name',
              ),
              buildTextField(
                controller: companyDetailsController,
                label: 'Company Details',
                hint: 'Enter company details',
              ),
              buildTextField(
                controller: companyEmailController,
                label: 'Company Email',
                hint: 'Enter company email',
              ),
              buildTextField(
                controller: companyPhoneController,
                label: 'Company Phone',
                hint: 'Enter company phone',
              ),
              buildTextField(
                controller: companyAddressController,
                label: 'Company Address',
                hint: 'Enter company address',
              ),
              buildTextField(
                controller: employeeSizeController,
                label: 'Employee Size',
                hint: 'Enter number of employees',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: minimumPadding * 2),
              ElevatedButton(
                onPressed: _updateCompany,
                child: Text('Update Company'),
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
  }) {
    return Padding(
      padding: EdgeInsets.only(top: minimumPadding, bottom: minimumPadding),
      child: TextFormField(
        controller: controller,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}
