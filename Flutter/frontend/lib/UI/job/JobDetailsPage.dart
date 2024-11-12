import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/Job.dart';
import '../../service/JobService.dart';


class JobDetailsPage extends StatefulWidget {
  final Job job;

  JobDetailsPage({required this.job});

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  late Job _job;
  late TextEditingController _jobTitleController;
  late TextEditingController _descriptionController;
  late TextEditingController _companyNameController;

  File? _image;

  @override
  void initState() {
    super.initState();
    _job = widget.job;

    _jobTitleController = TextEditingController(text: _job.jobTitle);
    _descriptionController = TextEditingController(text: _job.description);
    _companyNameController = TextEditingController(text: _job.companyName);
  }

  _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  _saveJob() async {
    try {
      // Update job details from controllers
      _job.jobTitle = _jobTitleController.text;
      _job.description = _descriptionController.text;
      _job.companyName = _companyNameController.text;

      // Call your JobService to save the job
      await JobService().saveJob(_job, _image);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Job added successfully")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  _updateJob() async {
    try {
      // Update job details from controllers
      _job.jobTitle = _jobTitleController.text;
      _job.description = _descriptionController.text;
      _job.companyName = _companyNameController.text;

      // Call your JobService to update the job
      await JobService().updateJob(_job.id!, _job, _image);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Job updated successfully")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  _deleteJob() async {
    try {
      await JobService().deleteJob(_job.id!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Job deleted successfully")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _jobTitleController,
                decoration: InputDecoration(labelText: 'Job Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _companyNameController,
                decoration: InputDecoration(labelText: 'Company Name'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text("Pick Image"),
              ),
              SizedBox(height: 20),
              _image == null ? Text("No image selected") : Image.file(_image!, height: 200),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _job.id == null ? _saveJob : _updateJob,
                child: Text(_job.id == null ? "Save Job" : "Update Job"),
              ),
              if (_job.id != null)
                ElevatedButton(
                  onPressed: _deleteJob,
                  child: Text("Delete Job"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
