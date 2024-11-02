import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateJob extends StatefulWidget {
  final String id; // Add the 'id' parameter

  UpdateJob({required this.id}); // Mark 'id' as required

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
    _fetchJobDetails(); // Load job details when the screen initializes
  }

  Future<void> _fetchJobDetails() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('http://192.168.88.243:8080/getjob/${widget.id}')); // Adjust URL
      if (response.statusCode == 200) {
        final job = json.decode(response.body);
        setState(() {
          jobTitleController.text = job['jobTitle'] ?? 'No title';
          descriptionController.text = job['description'] ?? 'No description';
          requirementsController.text = job['requirements'] ?? 'No requirements';
          locationController.text = job['location'] ?? 'Location not specified';
          salaryController.text = job['salary']?.toString() ?? '0.0';
          jobTypeController.text = job['jobType'] ?? 'Not specified';
          positionController.text = job['position'] ?? 'Not specified';
          skillsController.text = job['skills'] ?? 'No specific skills';
          companyNameController.text = job['companyName'] ?? 'Company name unavailable';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch job details')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateJob() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final response = await http.put(
          Uri.parse('http://localhost:8080/updatejob/${widget.id}'), // Adjust the URL
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'jobTitle': jobTitleController.text,
            'description': descriptionController.text,
            'requirements': requirementsController.text,
            'location': locationController.text,
            'salary': double.tryParse(salaryController.text) ?? 0.0,
            'jobType': jobTypeController.text,
            'position': positionController.text,
            'skills': skillsController.text,
            'companyName': companyNameController.text,
          }),
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Job updated successfully!')));
          Navigator.pop(context); // Go back after update
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update job')));
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
      appBar: AppBar(title: Text('Update Job')),
      body: Padding(
        padding: EdgeInsets.all(minimumPadding),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: jobTitleController,
                decoration: InputDecoration(labelText: 'Job Title'),
                validator: (value) => value!.isEmpty ? 'Please enter job title' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Please enter description' : null,
              ),
              TextFormField(
                controller: requirementsController,
                decoration: InputDecoration(labelText: 'Requirements'),
                validator: (value) => value!.isEmpty ? 'Please enter requirements' : null,
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) => value!.isEmpty ? 'Please enter location' : null,
              ),
              TextFormField(
                controller: salaryController,
                decoration: InputDecoration(labelText: 'Salary'),
                validator: (value) => value!.isEmpty ? 'Please enter salary' : null,
              ),
              TextFormField(
                controller: jobTypeController,
                decoration: InputDecoration(labelText: 'Job Type'),
                validator: (value) => value!.isEmpty ? 'Please enter job type' : null,
              ),
              TextFormField(
                controller: positionController,
                decoration: InputDecoration(labelText: 'Position'),
                validator: (value) => value!.isEmpty ? 'Please enter position' : null,
              ),
              TextFormField(
                controller: skillsController,
                decoration: InputDecoration(labelText: 'Skills'),
                validator: (value) => value!.isEmpty ? 'Please enter skills' : null,
              ),
              TextFormField(
                controller: companyNameController,
                decoration: InputDecoration(labelText: 'Company Name'),
                validator: (value) => value!.isEmpty ? 'Please enter company name' : null,
              ),
              SizedBox(height: minimumPadding * 2),
              ElevatedButton(
                onPressed: _updateJob,
                child: Text('Update Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
