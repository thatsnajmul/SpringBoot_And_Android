import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:http_parser/http_parser.dart';

class AddJob extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddJobState();
  }
}

class AddJobState extends State<AddJob> {
  final double minimumPadding = 5.0;
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController jobTypeController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Uint8List? _imageData;
  String? _imageName; // To store the selected image name

  // Function to pick an image from file input
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

  // Function to submit the job along with the image
  Future<void> _submitJob() async {
    if (_formKey.currentState?.validate() == true) {
      final jobData = {
        'jobTitle': jobTitleController.text,
        'description': descriptionController.text,
        'requirements': requirementsController.text,
        'location': locationController.text,
        'salary': double.tryParse(salaryController.text) ?? 0.0,
        'jobType': jobTypeController.text,
        'position': positionController.text,
        'skills': skillsController.text,
        'companyName': companyNameController.text,
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:8080/addjob'), // Update with your API URL
      );

      // Add job data as JSON
      request.fields['jobDetails'] = json.encode(jobData);

      if (_imageData != null) {
        // Add the image to the request
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            _imageData!,
            filename: _imageName ?? 'upload.jpg',
            contentType: MediaType('image', 'jpeg'), // Adjust MIME type if needed
          ),
        );
      }

      try {
        final response = await request.send();
        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pop(context); // Navigate back if successful
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add job: ${response.statusCode}')),
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
        title: Text("Add Job"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(minimumPadding * 2),
          child: ListView(
            children: <Widget>[
              buildTextField(
                controller: jobTitleController,
                label: 'Job Title',
                hint: 'Enter your Job Title',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: descriptionController,
                label: 'Job Description',
                hint: 'Enter job description',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: requirementsController,
                label: 'Requirements',
                hint: 'Enter job requirements',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: locationController,
                label: 'Location',
                hint: 'Enter job location',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: salaryController,
                label: 'Salary',
                hint: 'Enter salary amount',
                textStyle: textStyle,
                keyboardType: TextInputType.number,
              ),
              buildTextField(
                controller: jobTypeController,
                label: 'Job Type',
                hint: 'e.g., Full-time, Part-time',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: positionController,
                label: 'Position',
                hint: 'e.g., Junior, Senior, Intern',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: skillsController,
                label: 'Skills',
                hint: 'Comma-separated list of skills',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: companyNameController,
                label: 'Company Name',
                hint: 'Enter company name',
                textStyle: textStyle,
              ),
              Padding(
                padding: EdgeInsets.only(top: minimumPadding),
                child: ElevatedButton(
                  child: Text('Pick Image'),
                  onPressed: _pickImage, // Add the image picker functionality
                ),
              ),
              if (_imageData != null)
                Padding(
                  padding: EdgeInsets.only(top: minimumPadding),
                  child: Image.memory(_imageData!, height: 150, width: 150), // Display selected image
                ),
              Padding(
                padding: EdgeInsets.only(top: minimumPadding),
                child: ElevatedButton(
                  child: Text('Submit'),
                  onPressed: _submitJob,
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
