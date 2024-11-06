import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobApplication {
  final String applicantName;
  final String applicantEmail;
  final String applicantPhone;
  final String resumeLink;
  final String applicationDate;
  final String coverLetter;
  final String jobTitleApplied;
  final String skills; // String representation of skills
  final String jobTypeApplied;
  final String locationPreference;
  final String positionLevel;

  JobApplication({
    required this.applicantName,
    required this.applicantEmail,
    required this.applicantPhone,
    required this.resumeLink,
    required this.applicationDate,
    required this.coverLetter,
    required this.jobTitleApplied,
    required this.skills,
    required this.jobTypeApplied,
    required this.locationPreference,
    required this.positionLevel,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      applicantName: json['applicantName'],
      applicantEmail: json['applicantEmail'],
      applicantPhone: json['applicantPhone'],
      resumeLink: json['resumeLink'],
      applicationDate: json['applicationDate'],
      coverLetter: json['coverLetter'],
      jobTitleApplied: json['jobTitleApplied'],
      skills: json['skills'],
      jobTypeApplied: json['jobTypeApplied'],
      locationPreference: json['locationPreference'],
      positionLevel: json['positionLevel'],
    );
  }
}

class ViewJobApplication extends StatefulWidget {
  @override
  _ViewJobApplicationState createState() => _ViewJobApplicationState();
}

class _ViewJobApplicationState extends State<ViewJobApplication> {
  String errorMessage = '';
  List<JobApplication> applications = [];

  @override
  void initState() {
    super.initState();
    fetchApplications(); // Fetch existing applications on initialization
  }

  Future<void> fetchApplications() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.88.243:8080/jobapplications/getall'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        setState(() {
          applications = jsonResponse.map((data) => JobApplication.fromJson(data)).toList();
        });
      } else {
        throw Exception('Failed to load applications');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Job Application Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(errorMessage, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: applications.length,
                itemBuilder: (context, index) {
                  final application = applications[index];
                  return ListTile(
                    title: Text(application.applicantName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Applicant Name: ${application.applicantName}'),
                        Text('Applicant Email: ${application.applicantEmail}'),
                        Text('Phone: ${application.applicantPhone}'),
                        Text('resumeLink: ${application.resumeLink}'),
                        Text('applicationDate: ${application.applicationDate}'),
                        Text('coverLetter: ${application.coverLetter}'),
                        Text('jobTitleApplied: ${application.jobTitleApplied}'),
                        Text('skills: ${application.skills}'),
                        Text('jobTypeApplied: ${application.jobTypeApplied}'),
                        Text('locationPreference: ${application.locationPreference}'),
                        Text('positionLevel: ${application.positionLevel}'),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(), // Add separation between items
              ),
            ),
          ],
        ),
      ),
    );
  }
}
