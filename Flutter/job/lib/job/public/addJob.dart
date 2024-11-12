import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';  // For File
import 'package:image_picker/image_picker.dart';  // For Image Picker
import 'package:http_parser/http_parser.dart';  // For media type

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
  File? _image;  // To hold the selected image file

  final picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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

      // Prepare to send data with image
      var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://localhost:8080/addjob')  // Update with your API URL
      );

      // Add job data
      request.fields['jobDetails'] = json.encode(jobData);

      if (_image != null) {
        // Add the image to the request
        request.files.add(
          await http.MultipartFile.fromPath(
              'image',
              _image!.path,
              contentType: MediaType('image', 'jpeg')  // Change MIME type if needed
          ),
        );
      }

      try {
        final response = await request.send();
        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pop(context); // Navigate back if successful
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add job: ${response.statusCode}')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
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
                  onPressed: _pickImage,  // Add the image picker functionality
                ),
              ),
              if (_image != null)
                Padding(
                  padding: EdgeInsets.only(top: minimumPadding),
                  child: Image.file(_image!, height: 150, width: 150),  // Display selected image
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
