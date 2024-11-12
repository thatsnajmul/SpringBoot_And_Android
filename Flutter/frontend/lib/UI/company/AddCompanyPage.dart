import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/Company.dart';
import '../../service/CompanyService.dart';


class AddCompanyPage extends StatefulWidget {
  @override
  _AddCompanyPageState createState() => _AddCompanyPageState();
}

class _AddCompanyPageState extends State<AddCompanyPage> {
  final _formKey = GlobalKey<FormState>();
  final _companyService = CompanyService();
  final _imagePicker = ImagePicker();

  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _companyImageController = TextEditingController();
  TextEditingController _companyDetailsController = TextEditingController();
  TextEditingController _companyEmailController = TextEditingController();
  TextEditingController _companyAddressController = TextEditingController();
  TextEditingController _companyPhoneController = TextEditingController();
  TextEditingController _employeeSizeController = TextEditingController();

  XFile? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Company')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _companyNameController,
                decoration: InputDecoration(labelText: 'Company Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter company name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _companyImageController,
                decoration: InputDecoration(labelText: 'Company Image URL'),
              ),
              TextFormField(
                controller: _companyDetailsController,
                decoration: InputDecoration(labelText: 'Company Details'),
              ),
              TextFormField(
                controller: _companyEmailController,
                decoration: InputDecoration(labelText: 'Company Email'),
              ),
              TextFormField(
                controller: _companyAddressController,
                decoration: InputDecoration(labelText: 'Company Address'),
              ),
              TextFormField(
                controller: _companyPhoneController,
                decoration: InputDecoration(labelText: 'Company Phone'),
              ),
              TextFormField(
                controller: _employeeSizeController,
                decoration: InputDecoration(labelText: 'Employee Size'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Pick image from gallery
                  _selectedImage = await _imagePicker.pickImage(source: ImageSource.gallery);

                  setState(() {});
                },
                child: Text('Pick Image'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final company = Company(
                      companyName: _companyNameController.text,
                      companyImage: _companyImageController.text,
                      companyDetails: _companyDetailsController.text,
                      companyEmail: _companyEmailController.text,
                      companyAddress: _companyAddressController.text,
                      companyPhone: _companyPhoneController.text,
                      employeeSize: int.parse(_employeeSizeController.text),
                      image: _selectedImage?.path ?? '',
                    );

                    try {
                      await _companyService.saveCompany(company, _selectedImage);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Company added successfully')));
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add company')));
                    }
                  }
                },
                child: Text('Save Company'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
