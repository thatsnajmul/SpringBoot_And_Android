import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateJobApplication extends StatefulWidget {
  final String applicationId; // Add the 'id' parameter

  UpdateJobApplication({required this.applicationId}); // Mark 'id' as required

  @override
  _UpdateJobApplicationState createState() => _UpdateJobApplicationState();
}

class _UpdateJobApplicationState extends State<UpdateJobApplication> {
  final double minimumPadding = 5.0;
  final TextEditingController applicantNameController = TextEditingController();
  final TextEditingController applicantEmailController = TextEditingController();
  final TextEditingController applicantPhoneController = TextEditingController();
  final TextEditingController resumeLinkController = TextEditingController();
  final TextEditingController applicationDateController = TextEditingController();
  final TextEditingController applicationStatusController = TextEditingController();
  final TextEditingController coverLetterController = TextEditingController();
  final TextEditingController jobTitleAppliedController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController jobTypeAppliedController = TextEditingController();
  final TextEditingController locationPreferenceController = TextEditingController();
  final TextEditingController positionLevelController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchJobApplicationDetails(); // Load job application details when the screen initializes
  }

  Future<void> _fetchJobApplicationDetails() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/jobapplications/get/${widget.applicationId}'), // Adjust URL as needed
      );
      if (response.statusCode == 200) {
        final application = json.decode(response.body);
        setState(() {
          applicantNameController.text = application['applicantName'] ?? '';
          applicantEmailController.text = application['applicantEmail'] ?? '';
          applicantPhoneController.text = application['applicantPhone'] ?? '';
          resumeLinkController.text = application['resumeLink'] ?? '';
          applicationDateController.text = application['applicationDate'] ?? '';
          applicationStatusController.text = application['applicationStatus'] ?? '';
          coverLetterController.text = application['coverLetter'] ?? '';
          jobTitleAppliedController.text = application['jobTitleApplied'] ?? '';
          skillsController.text = application['skills'] ?? '';
          jobTypeAppliedController.text = application['jobTypeApplied'] ?? '';
          locationPreferenceController.text = application['locationPreference'] ?? '';
          positionLevelController.text = application['positionLevel'] ?? '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch application details')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateJobApplication() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final response = await http.put(
          Uri.parse('http://localhost:8080/update/${widget.applicationId}'), // Adjust the URL
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'applicantName': applicantNameController.text,
            'applicantEmail': applicantEmailController.text,
            'applicantPhone': applicantPhoneController.text,
            'resumeLink': resumeLinkController.text,
            'applicationDate': applicationDateController.text,
            'applicationStatus': applicationStatusController.text,
            'coverLetter': coverLetterController.text,
            'jobTitleApplied': jobTitleAppliedController.text,
            'skills': skillsController.text,
            'jobTypeApplied': jobTypeAppliedController.text,
            'locationPreference': locationPreferenceController.text,
            'positionLevel': positionLevelController.text,
          }),
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Application updated successfully!')));
          Navigator.pop(context); // Go back after update
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update application')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Job Application')),
      body: Padding(
        padding: EdgeInsets.all(minimumPadding),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: applicantNameController,
                decoration: InputDecoration(labelText: 'Applicant Name'),
                validator: (value) => value!.isEmpty ? 'Please enter applicant name' : null,
              ),
              TextFormField(
                controller: applicantEmailController,
                decoration: InputDecoration(labelText: 'Applicant Email'),
                validator: (value) => value!.isEmpty ? 'Please enter applicant email' : null,
              ),
              TextFormField(
                controller: applicantPhoneController,
                decoration: InputDecoration(labelText: 'Applicant Phone'),
                validator: (value) => value!.isEmpty ? 'Please enter applicant phone' : null,
              ),
              TextFormField(
                controller: resumeLinkController,
                decoration: InputDecoration(labelText: 'Resume Link'),
                validator: (value) => value!.isEmpty ? 'Please enter resume link' : null,
              ),
              TextFormField(
                controller: applicationDateController,
                decoration: InputDecoration(labelText: 'Application Date'),
                validator: (value) => value!.isEmpty ? 'Please enter application date' : null,
              ),
              TextFormField(
                controller: applicationStatusController,
                decoration: InputDecoration(labelText: 'Application Status'),
                validator: (value) => value!.isEmpty ? 'Please enter application status' : null,
              ),
              TextFormField(
                controller: coverLetterController,
                decoration: InputDecoration(labelText: 'Cover Letter'),
                validator: (value) => value!.isEmpty ? 'Please enter cover letter' : null,
              ),
              TextFormField(
                controller: jobTitleAppliedController,
                decoration: InputDecoration(labelText: 'Job Title Applied'),
                validator: (value) => value!.isEmpty ? 'Please enter job title applied' : null,
              ),
              TextFormField(
                controller: skillsController,
                decoration: InputDecoration(labelText: 'Skills'),
                validator: (value) => value!.isEmpty ? 'Please enter skills' : null,
              ),
              TextFormField(
                controller: jobTypeAppliedController,
                decoration: InputDecoration(labelText: 'Job Type Applied'),
                validator: (value) => value!.isEmpty ? 'Please enter job type applied' : null,
              ),
              TextFormField(
                controller: locationPreferenceController,
                decoration: InputDecoration(labelText: 'Location Preference'),
                validator: (value) => value!.isEmpty ? 'Please enter location preference' : null,
              ),
              TextFormField(
                controller: positionLevelController,
                decoration: InputDecoration(labelText: 'Position Level'),
                validator: (value) => value!.isEmpty ? 'Please enter position level' : null,
              ),
              SizedBox(height: minimumPadding * 2),
              ElevatedButton(
                onPressed: _updateJobApplication,
                child: Text('Update Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
