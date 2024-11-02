import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:job/job-application/admin/UpdateJobApplication.dart';

// Model class for job applications
class JobApplication {
  final String id; // ID for the job application
  final String applicantName;
  final String? applicantEmail; // Nullable
  final String? applicantPhone; // Nullable
  final String? resumeLink; // Nullable
  final String applicationDate;
  final String? coverLetter; // Nullable
  final String jobTitleApplied;
  final String skills; // String representation of skills
  final String jobTypeApplied;
  final String? locationPreference; // Nullable
  final String? positionLevel; // Nullable

  JobApplication({
    required this.id,
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
      id: json['id'] ?? '', // Provide default value if null
      applicantName: json['applicantName'] ?? '',
      applicantEmail: json['applicantEmail'], // Nullable, so no default needed
      applicantPhone: json['applicantPhone'], // Nullable
      resumeLink: json['resumeLink'], // Nullable
      applicationDate: json['applicationDate'] ?? '', // Provide default value if null
      coverLetter: json['coverLetter'], // Nullable
      jobTitleApplied: json['jobTitleApplied'] ?? '',
      skills: json['skills'] ?? '', // Provide default value if null
      jobTypeApplied: json['jobTypeApplied'] ?? '',
      locationPreference: json['locationPreference'], // Nullable
      positionLevel: json['positionLevel'], // Nullable
    );
  }
}

// Stateful widget to view job applications
class AdminViewJobApplications extends StatefulWidget {
  final String jobTitle; // Job title received from the selected job
  const AdminViewJobApplications({Key? key, required this.jobTitle}) : super(key: key);

  @override
  _AdminViewJobApplicationsState createState() => _AdminViewJobApplicationsState();
}

class _AdminViewJobApplicationsState extends State<AdminViewJobApplications> {
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

  Future<void> deleteApplication(String id) async {
    try {
      final response = await http.delete(Uri.parse('http://192.168.88.243:8080/jobapplications/delete/$id'));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Application deleted successfully!')));
        fetchApplications(); // Refresh the list after deletion
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
      appBar: AppBar(title: Text('Applications for ${widget.jobTitle}')),
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
                        Text('Applicant Email: ${application.applicantEmail ?? 'N/A'}'), // Handle nullable
                        Text('Phone: ${application.applicantPhone ?? 'N/A'}'), // Handle nullable
                        Text('Resume Link: ${application.resumeLink ?? 'N/A'}'), // Handle nullable
                        Text('Application Date: ${application.applicationDate}'),
                        Text('Cover Letter: ${application.coverLetter ?? 'N/A'}'), // Handle nullable
                        Text('Job Title Applied: ${application.jobTitleApplied}'),
                        Text('Skills: ${application.skills}'),
                        Text('Job Type: ${application.jobTypeApplied}'),
                        Text('Location Preference: ${application.locationPreference ?? 'N/A'}'), // Handle nullable
                        Text('Position Level: ${application.positionLevel ?? 'N/A'}'), // Handle nullable
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateJobApplication(id: application.id), // Ensure UpdateJobApplication exists
                              ),
                            ).then((_) => fetchApplications()); // Refresh applications on return
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => deleteApplication(application.id), // Call the delete function
                        ),
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
