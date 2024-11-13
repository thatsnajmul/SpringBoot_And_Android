import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:http_parser/http_parser.dart';

class AddCompany extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddCompanyState();
  }
}

class AddCompanyState extends State<AddCompany> {
  final double minimumPadding = 5.0;
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyDetailsController = TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();
  final TextEditingController companyPhoneController = TextEditingController();
  final TextEditingController companyAddressController = TextEditingController();
  final TextEditingController employeeSizeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Uint8List? _imageData;
  String? _imageName;

  Future<void> _pickImage() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();

        reader.onLoadEnd.listen((event) {
          setState(() {
            _imageData = reader.result as Uint8List;
            _imageName = file.name;
          });
        });
        reader.readAsArrayBuffer(file);
      }
    });
  }

  Future<void> _submitCompany() async {
    if (_formKey.currentState?.validate() == true) {
      final companyData = {
        'companyName': companyNameController.text,
        'companyDetails': companyDetailsController.text,
        'companyEmail': companyEmailController.text,
        'companyPhone': companyPhoneController.text,
        'companyAddress': companyAddressController.text,
        'employeeSize': int.tryParse(employeeSizeController.text) ?? 0,
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:8080/api/companies/add-company'),
      );

      request.fields['companyDetails'] = json.encode(companyData);

      // Update: Use 'image' as the backend field name for the image
      if (_imageData != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',  // Updated field name to match backend expectation
            _imageData!,
            filename: _imageName ?? 'company_image.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      try {
        final response = await request.send();

        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add company: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleSmall;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Company"),
      ),
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
                textStyle: textStyle,
              ),
              buildTextField(
                controller: companyDetailsController,
                label: 'Company Details',
                hint: 'Enter company details',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: companyEmailController,
                label: 'Company Email',
                hint: 'Enter company email',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: companyPhoneController,
                label: 'Company Phone',
                hint: 'Enter company phone',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: companyAddressController,
                label: 'Company Address',
                hint: 'Enter company address',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: employeeSizeController,
                label: 'Employee Size',
                hint: 'Enter number of employees',
                textStyle: textStyle,
                keyboardType: TextInputType.number,
              ),
              Padding(
                padding: EdgeInsets.only(top: minimumPadding),
                child: ElevatedButton(
                  child: Text('Pick Image'),
                  onPressed: _pickImage,
                ),
              ),
              if (_imageData != null)
                Padding(
                  padding: EdgeInsets.only(top: minimumPadding),
                  child: Image.memory(_imageData!, height: 150, width: 150),
                ),
              Padding(
                padding: EdgeInsets.only(top: minimumPadding),
                child: ElevatedButton(
                  child: Text('Submit'),
                  onPressed: _submitCompany,
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
    TextStyle? textStyle,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: minimumPadding, bottom: minimumPadding),
      child: TextFormField(
        style: textStyle,
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
          labelStyle: textStyle,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}
