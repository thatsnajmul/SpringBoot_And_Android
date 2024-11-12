import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../model/JobApplication.dart';
import '../../service/JobApplicationService.dart';


class JobApplicationScreen extends StatefulWidget {
  @override
  _JobApplicationScreenState createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {
  final JobApplicationService _jobApplicationService = JobApplicationService();
  late Future<List<JobApplication>> futureApplications;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    futureApplications = _jobApplicationService.fetchJobApplications();
  }

  _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  _saveJobApplication() async {
    if (_selectedImage != null) {
      JobApplication jobApplication = JobApplication(
        applicantName: 'John Doe',
        image: 'image.jpg',  // This will be replaced with actual image
        expectedSalary: 5000.00,
        applicantEmail: 'john.doe@example.com',
        applicantPhone: '1234567890',
        resumeLink: '',
        applicationDate: '2024-11-12',
        applicationStatus: 'Pending',
        coverLetter: 'Cover Letter content',
        jobTitleApplied: 'Software Developer',
        skills: 'Flutter, Dart',
        jobTypeApplied: 'Full-time',
        locationPreference: 'Remote',
        positionLevel: 'Junior',
        jobId: 1,  // Replace with actual job ID
      );

      await _jobApplicationService.saveJobApplication(jobApplication, _selectedImage!);
      setState(() {
        futureApplications = _jobApplicationService.fetchJobApplications();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Job Applications")),
      body: FutureBuilder<List<JobApplication>>(
        future: futureApplications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No applications found'));
          } else {
            List<JobApplication> jobApplications = snapshot.data!;
            return ListView.builder(
              itemCount: jobApplications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(jobApplications[index].applicantName),
                  subtitle: Text(jobApplications[index].jobTitleApplied),
                  onTap: () {
                    // Implement navigation to edit or view job application details
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveJobApplication,
        child: Icon(Icons.add),
      ),
    );
  }
}
