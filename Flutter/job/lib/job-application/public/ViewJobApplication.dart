import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class JobApplication {
  final String applicantName;
  final String applicantEmail;
  final String applicantPhone;
  final String resumeLink;
  final String applicationDate;
  final String coverLetter;
  final String jobTitleApplied;
  final String skills;
  final String jobTypeApplied;
  final String locationPreference;
  final String positionLevel;
  final String aplicantImage;

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
    required this.aplicantImage,
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
      aplicantImage: json['applicantImage'],
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
  List<JobApplication> filteredApplications = [];
  String searchQuery = '';
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    fetchApplications(); // Fetch existing applications on initialization
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
        throw Exception('Failed to load applications');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

  // Method to filter applications based on selected filter option
  void filterApplications(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == 'All') {
        filteredApplications = applications;
      } else {
        filteredApplications = applications.where((app) {
          return app.jobTypeApplied == filter || app.locationPreference == filter || app.positionLevel == filter;
        }).toList();
      }
    });
  }

  // Method to search applications based on search query
  void searchApplications(String query) {
    setState(() {
      searchQuery = query;
      filteredApplications = applications
          .where((app) => app.applicantName.toLowerCase().contains(query.toLowerCase()) ||
          app.jobTitleApplied.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Method to generate the PDF document
  Future<pw.Document> generatePDF() async {
    final pdf = pw.Document();

    // Add pages for each job application
    for (var application in filteredApplications) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Applicant Name: ${application.applicantName}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Text('Applicant Email: ${application.applicantEmail}'),
                pw.Text('Phone: ${application.applicantPhone}'),
                pw.Text('Resume Link: ${application.resumeLink}'),
                pw.Text('Application Date: ${application.applicationDate}'),
                pw.Text('Cover Letter: ${application.coverLetter}'),
                pw.Text('Job Title Applied: ${application.jobTitleApplied}'),
                pw.Text('Skills: ${application.skills}'),
                pw.Text('Job Type Applied: ${application.jobTypeApplied}'),
                pw.Text('Location Preference: ${application.locationPreference}'),
                pw.Text('Position Level: ${application.positionLevel}'),
                pw.SizedBox(height: 20),
              ],
            );
          },
        ),
      );
    }
    return pdf;
  }

  // Method to download the PDF
  Future<void> generateAndDownloadPDF() async {
    try {
      final pdf = await generatePDF();
      final output = await getTemporaryDirectory();
      final filePath = '${output.path}/job_applications.pdf';
      final file = File(filePath);

      // Save the PDF file to disk
      await file.writeAsBytes(await pdf.save());

      // Share the PDF
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'job_applications.pdf');
    } catch (e) {
      setState(() {
        errorMessage = 'Error saving or sharing PDF: $e';
      });
    }
  }

  // Method to print the PDF
  Future<void> printPDF() async {
    try {
      final pdf = await generatePDF();
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (e) {
      setState(() {
        errorMessage = 'Error printing PDF: $e';
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
            // Search Bar
            TextField(
              onChanged: searchApplications,
              decoration: InputDecoration(
                labelText: 'Search Applicants',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            // Filter Dropdown
            DropdownButton<String>(
              value: selectedFilter,
              onChanged: (value) {
                if (value != null) {
                  filterApplications(value);
                }
              },
              items: <String>['All', 'Full-time', 'Part-time', 'Remote', 'Internship']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // List of Job Applications
            Expanded(
              child: ListView.separated(
                itemCount: filteredApplications.length,
                itemBuilder: (context, index) {
                  final application = filteredApplications[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        application.applicantName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Row(
                        children: [
                          // Left side: Applicant image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: application.aplicantImage.isNotEmpty
                                ? Image.network(
                              "http://localhost:8080/uploads/job-applications/" + application.aplicantImage,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[200],
                              child: Center(child: Text('No Image')),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          // Right side: Application details and buttons
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailText('Email:', application.applicantEmail),
                                _buildDetailText('Phone:', application.applicantPhone),
                                _buildDetailText('Resume Link:', application.resumeLink),
                                _buildDetailText('Application Date:', application.applicationDate),
                                _buildDetailText('Job Title Applied:', application.jobTitleApplied),
                                _buildDetailText('Skills:', application.skills),
                                _buildDetailText('Job Type:', application.jobTypeApplied),
                                _buildDetailText('Location Preference:', application.locationPreference),
                                _buildDetailText('Position Level:', application.positionLevel),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: generateAndDownloadPDF,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                      ),
                                      child: Text('Download PDF'),
                                    ),
                                    SizedBox(width: 8.0),
                                    ElevatedButton(
                                      onPressed: printPDF,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                      ),
                                      child: Text('Print PDF'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to display application details
  Widget _buildDetailText(String title, String value) {
    return Text(
      '$title $value',
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
    );
  }
}
