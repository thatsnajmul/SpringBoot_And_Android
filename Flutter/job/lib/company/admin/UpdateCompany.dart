import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateCompany extends StatefulWidget {
  final int companyId;
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

  Future<void> fetchCompanyDetails() async {
    final response = await http.get(
      Uri.parse('http://192.168.88.243:8080/api/companies/${widget.companyId}'),
    );

    if (response.statusCode == 200) {
      final company = json.decode(response.body);
      companyNameController.text = company['companyName'];
      companyDetailsController.text = company['companyDetails'];
      companyEmailController.text = company['companyEmail'];
      companyPhoneController.text = company['companyPhone'];
      companyAddressController.text = company['companyAddress'];
      employeeSizeController.text = company['employeeSize'].toString();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load company details')));
    }
  }

  Future<void> _updateCompany() async {
    if (_formKey.currentState?.validate() == true) {
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
          Uri.parse('http://192.168.88.243:8080/api/companies/${widget.companyId}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(updatedCompanyData),
        );

        if (response.statusCode == 200) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update company')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCompanyDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Company')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(minimumPadding * 2),
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
              Padding(
                padding: EdgeInsets.only(top: minimumPadding),
                child: ElevatedButton(
                  child: Text('Update'),
                  onPressed: _updateCompany,
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
