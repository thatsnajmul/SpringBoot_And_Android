import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddJobApplication extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddJobApplicationState();
  }
}

class AddJobApplicationState extends State<AddJobApplication> {
  final double minimumPadding = 5.0;

  // Text editing controllers
  final TextEditingController applicantNameController = TextEditingController();
  final TextEditingController applicantEmailController = TextEditingController();
  final TextEditingController applicantPhoneController = TextEditingController();
  final TextEditingController resumeLinkController = TextEditingController();
  final TextEditingController applicationDateController = TextEditingController();
  final TextEditingController coverLetterController = TextEditingController();
  final TextEditingController jobTitleAppliedController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController jobTypeAppliedController = TextEditingController();
  final TextEditingController locationPreferenceController = TextEditingController();
  final TextEditingController positionLevelController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _submitJobApplication() async {
    if (_formKey.currentState?.validate() == true) {
      // Prepare application data
      final applicationData = {
        'applicantName': applicantNameController.text,
        'applicantEmail': applicantEmailController.text,
        'applicantPhone': applicantPhoneController.text,
        'resumeLink': resumeLinkController.text,
        'applicationDate': applicationDateController.text,
        'coverLetter': coverLetterController.text,
        'jobTitleApplied': jobTitleAppliedController.text,
        // Store skills as a single string
        'skills': skillsController.text, // Directly use the input as a string
        'jobTypeApplied': jobTypeAppliedController.text,
        'locationPreference': locationPreferenceController.text,
        'positionLevel': positionLevelController.text,
      };

      // Debug print to verify applicationData content
      print("Application Data to be sent: ${json.encode(applicationData)}");

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/jobapplications/add'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(applicationData),
        );

        print('Response status: ${response.statusCode}'); // Log status code
        print('Response body: ${response.body}'); // Log response body

        // Check if the response status is successful
        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pop(context); // Navigate back if successful
        } else {
          // Show error message if the response was not successful
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add application: ${response.statusCode} - ${response.body}')),
          );
        }
      } catch (e) {
        // Catch any other errors and display a SnackBar
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
        title: Text("Add Job Application"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(minimumPadding * 2),
          child: ListView(
            children: <Widget>[
              buildTextField(
                controller: applicantNameController,
                label: 'Applicant Name',
                hint: 'Enter your name',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: applicantEmailController,
                label: 'Applicant Email',
                hint: 'Enter your email',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: applicantPhoneController,
                label: 'Applicant Phone',
                hint: 'Enter your phone number',
                textStyle: textStyle,
                keyboardType: TextInputType.phone,
              ),
              buildTextField(
                controller: resumeLinkController,
                label: 'Resume Link',
                hint: 'Enter link to your resume',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: applicationDateController,
                label: 'Application Date',
                hint: 'Enter application date (YYYY-MM-DD)',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: coverLetterController,
                label: 'Cover Letter',
                hint: 'Enter cover letter',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: jobTitleAppliedController,
                label: 'Job Title Applied',
                hint: 'Enter job title you applied for',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: skillsController,
                label: 'Skills',
                hint: 'Comma-separated list of skills',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: jobTypeAppliedController,
                label: 'Job Type Applied',
                hint: 'e.g., Full-time, Part-time',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: locationPreferenceController,
                label: 'Location Preference',
                hint: 'Enter preferred job location',
                textStyle: textStyle,
              ),
              buildTextField(
                controller: positionLevelController,
                label: 'Position Level',
                hint: 'e.g., Junior, Senior',
                textStyle: textStyle,
              ),
              Padding(
                padding: EdgeInsets.only(top: minimumPadding),
                child: ElevatedButton(
                  child: Text('Submit'),
                  onPressed: _submitJobApplication,
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
