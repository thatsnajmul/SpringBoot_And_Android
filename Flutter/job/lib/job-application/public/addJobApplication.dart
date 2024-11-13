import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';

class AddJobApplication extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddJobApplicationState();
  }
}

class AddJobApplicationState extends State<AddJobApplication> {
  final double minimumPadding = 5.0;
  final _formKey = GlobalKey<FormState>();

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

  Uint8List? applicantImage;
  String? imageName;

  // Function to pick and resize image
  Future<void> _pickImage() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) async {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();

        reader.onLoadEnd.listen((event) async {
          setState(() {
            applicantImage = reader.result as Uint8List;
            imageName = file.name;
          });

          // Resize image (optional size limits)
          final img.Image image = img.decodeImage(applicantImage!)!;
          final resizedImage = img.copyResize(image, width: 300); // Adjust the width here
          applicantImage = Uint8List.fromList(img.encodeJpg(resizedImage)); // Convert back to Uint8List
        });
        reader.readAsArrayBuffer(file);
      }
    });
  }

  // Function to select application date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        // Format the selected date as yyyy-MM-dd
        final formattedDate =
            "${picked.year.toString()}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        applicationDateController.text = formattedDate; // Store formatted date
      });
    }
  }


  // Function to submit job application
  Future<void> _submitJobApplication() async {
    if (_formKey.currentState?.validate() == true) {
      final applicationData = {
        'applicantName': applicantNameController.text,
        'applicantEmail': applicantEmailController.text,
        'applicantPhone': applicantPhoneController.text,
        'resumeLink': resumeLinkController.text,
        'applicationDate': applicationDateController.text,  // Direct date as string
        'coverLetter': coverLetterController.text,
        'jobTitleApplied': jobTitleAppliedController.text,
        'skills': skillsController.text,
        'jobTypeApplied': jobTypeAppliedController.text,
        'locationPreference': locationPreferenceController.text,
        'positionLevel': positionLevelController.text,
      };

      // Log application data to ensure it is formatted correctly
      print("Sending data: ${jsonEncode(applicationData)}");

      final uri = Uri.parse('http://localhost:8080/api/job-applications/add');
      final request = http.MultipartRequest('POST', uri);
      request.fields['jobApplication'] = jsonEncode(applicationData);

      if (applicantImage != null && imageName != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'applicantImage',
          applicantImage!,
          filename: imageName,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      try {
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        // Log the response status and body
        print("Response Status: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 201) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: ${response.statusCode} - ${response.body}')),
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
        title: Text("Add Job Application"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(minimumPadding * 2),
          child: ListView(
            children: <Widget>[
              buildTextField(applicantNameController, 'Applicant Name', 'Enter your name', textStyle),
              buildTextField(applicantEmailController, 'Applicant Email', 'Enter your email', textStyle),
              buildTextField(applicantPhoneController, 'Applicant Phone', 'Enter phone number', textStyle, keyboardType: TextInputType.phone),
              buildTextField(resumeLinkController, 'Resume Link', 'Enter resume link', textStyle),
              buildTextField(applicationDateController, 'Application Date', 'dd-MM-yy', textStyle),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text('Select Date'),
              ),
              buildTextField(coverLetterController, 'Cover Letter', 'Enter cover letter', textStyle),
              buildTextField(jobTitleAppliedController, 'Job Title', 'Enter job title', textStyle),
              buildTextField(skillsController, 'Skills', 'Comma-separated skills', textStyle),
              buildTextField(jobTypeAppliedController, 'Job Type', 'Full-time/Part-time', textStyle),
              buildTextField(locationPreferenceController, 'Location', 'Preferred location', textStyle),
              buildTextField(positionLevelController, 'Position Level', 'Junior/Senior', textStyle),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              if (applicantImage != null) ...[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    width: 150,
                    height: 150,
                    child: Image.memory(applicantImage!, fit: BoxFit.cover),
                  ),
                ),
              ],
              Padding(
                padding: EdgeInsets.symmetric(vertical: minimumPadding),
                child: ElevatedButton(
                  onPressed: _submitJobApplication,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function for building text fields
  Widget buildTextField(TextEditingController controller, String label, String hint, TextStyle? style, {TextInputType? keyboardType}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: minimumPadding),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, hintText: hint),
        style: style,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }
}
