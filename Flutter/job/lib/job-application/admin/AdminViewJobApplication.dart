import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:job/job-application/admin/UpdateJobApplication.dart';

class JobApplication {
  final String applicationId;
  final String applicantName;
  final String? applicantEmail;
  final String? applicantPhone;
  final String? resumeLink;
  final String applicationDate;
  final String? coverLetter;
  final String jobTitleApplied;
  final String skills;
  final String jobTypeApplied;
  final String? locationPreference;
  final String? positionLevel;

  JobApplication({
    required this.applicationId,
    required this.applicantName,
    this.applicantEmail,
    this.applicantPhone,
    this.resumeLink,
    required this.applicationDate,
    this.coverLetter,
    required this.jobTitleApplied,
    required this.skills,
    required this.jobTypeApplied,
    this.locationPreference,
    this.positionLevel,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      applicationId: json['applicationId'] is int
          ? json['applicationId'].toString()
          : json['applicationId'] ?? '',
      applicantName: json['applicantName'] ?? '',
      applicantEmail: json['applicantEmail'],
      applicantPhone: json['applicantPhone'],
      resumeLink: json['resumeLink'],
      applicationDate: json['applicationDate'] ?? '',
      coverLetter: json['coverLetter'],
      jobTitleApplied: json['jobTitleApplied'] ?? '',
      skills: json['skills'] ?? '',
      jobTypeApplied: json['jobTypeApplied'] ?? '',
      locationPreference: json['locationPreference'],
      positionLevel: json['positionLevel'],
    );
  }
}

class AdminViewJobApplications extends StatefulWidget {
  @override
  _AdminViewJobApplicationsState createState() => _AdminViewJobApplicationsState();
}

class _AdminViewJobApplicationsState extends State<AdminViewJobApplications> {
  String errorMessage = '';
  List<JobApplication> applications = [];
  List<JobApplication> filteredApplications = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchApplications();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchApplications() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/job-applications/getall'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        setState(() {
          applications = jsonResponse.map((data) => JobApplication.fromJson(data)).toList();
          filteredApplications = applications;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load applications';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error: $error';
      });
    }
  }

  void onSearchChanged() {
    setState(() {
      filteredApplications = applications
          .where((application) =>
      application.applicantName.toLowerCase().contains(searchController.text.toLowerCase()) ||
          (application.applicantEmail?.toLowerCase().contains(searchController.text.toLowerCase()) ?? false))
          .toList();
    });
  }

  Future<void> deleteApplication(String applicationId) async {
    try {
      final response = await http.delete(Uri.parse('http://localhost:8080/api/job-applications/delete/$applicationId'));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Application deleted successfully!')));
        fetchApplications();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete application')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Job Applications')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by applicant name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: TextStyle(color: Colors.red)),
            Expanded(
              child: ListView.builder(
                itemCount: filteredApplications.length,
                itemBuilder: (context, index) {
                  final application = filteredApplications[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(application.applicantName, style: Theme.of(context).textTheme.titleLarge),
                          SizedBox(height: 5),
                          Text('Email: ${application.applicantEmail ?? 'N/A'}', style: TextStyle(color: Colors.grey[600])),
                          Text('Phone: ${application.applicantPhone ?? 'N/A'}', style: TextStyle(color: Colors.grey[600])),
                          Text('Resume: ${application.resumeLink ?? 'N/A'}', style: TextStyle(color: Colors.grey[600])),
                          Text('Applied Date: ${application.applicationDate}', style: TextStyle(color: Colors.grey[600])),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateJobApplication(applicationId: application.applicationId),
                                    ),
                                  ).then((_) => fetchApplications());
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteApplication(application.applicationId),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
