import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateJob extends StatefulWidget {
  final String jobId; // ID of the job to update

  UpdateJob({required this.jobId});

  @override
  _UpdateJobState createState() => _UpdateJobState();
}

class _UpdateJobState extends State<UpdateJob> {
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchJobDetails();
  }

  Future<void> _fetchJobDetails() async {
    // Fetch job details from API
    final response = await http.get(Uri.parse('http://localhost:8080/jobs/${widget.jobId}')); // Replace with your API URL
    if (response.statusCode == 200) {
      final job = json.decode(response.body);
      jobTitleController.text = job['job_title'];
      descriptionController.text = job['description'];
      requirementsController.text = job['requirements'];
      locationController.text = job['location'];
      salaryController.text = job['salary'].toString();
      jobTypeController.text = job['job_type'];
      positionController.text = job['position'];
      skillsController.text = job['skills'];
      companyNameController.text = job['company_name'];
    }
  }

  Future<void> _updateJob() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.put(
      Uri.parse('http://localhost:8080/updatejob/${widget.jobId}'), // Replace with your API URL
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'job_title': jobTitleController.text,
        'description': descriptionController.text,
        'requirements': requirementsController.text,
        'location': locationController.text,
        'salary': double.parse(salaryController.text),
        'job_type': jobTypeController.text,
        'position': positionController.text,
        'skills': skillsController.text,
        'company_name': companyNameController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Job updated successfully!')));
      Navigator.pop(context); // Go back to previous screen
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update job')));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Job"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(minimumPadding * 2),
          child: ListView(
            children: <Widget>[
              buildTextField(jobTitleController, 'Job Title', 'Enter your Job Title'),
              buildTextField(descriptionController, 'Job Description', 'Enter job description'),
              buildTextField(requirementsController, 'Requirements', 'Enter job requirements'),
              buildTextField(locationController, 'Location', 'Enter job location'),
              buildTextField(salaryController, 'Salary', 'Enter salary amount', keyboardType: TextInputType.number),
              buildTextField(jobTypeController, 'Job Type', 'e.g., Full-time, Part-time'),
              buildTextField(positionController, 'Position', 'e.g., Junior, Senior, Intern'),
              buildTextField(skillsController, 'Skills', 'Comma-separated list of skills'),
              buildTextField(companyNameController, 'Company Name', 'Enter company name'),
              Padding(
                padding: EdgeInsets.only(top: minimumPadding),
                child: ElevatedButton(
                  child: Text('Update'),
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true) {
                      _updateJob();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, String hint, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.only(top: minimumPadding, bottom: minimumPadding),
      child: TextFormField(
        controller: controller,
        validator: (value) {
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
