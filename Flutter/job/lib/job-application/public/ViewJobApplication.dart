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
      final response = await http.get(Uri.parse('http://localhost:8080/api/job-applications/getall'));
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

  // Method to generate the PDF document
  Future<pw.Document> generatePDF() async {
    final pdf = pw.Document();

    // Add pages for each job application
    for (var application in applications) {
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
                        Text('Resume Link: ${application.resumeLink}'),
                        Text('Application Date: ${application.applicationDate}'),
                        Text('Cover Letter: ${application.coverLetter}'),
                        Text('Job Title Applied: ${application.jobTitleApplied}'),
                        Text('Skills: ${application.skills}'),
                        Text('Job Type Applied: ${application.jobTypeApplied}'),
                        Text('Location Preference: ${application.locationPreference}'),
                        Text('Position Level: ${application.positionLevel}'),

                        // Button to download PDF
                        ElevatedButton(
                          onPressed: generateAndDownloadPDF,
                          child: Text('Download as PDF'),
                        ),
                        // Button to print PDF
                        ElevatedButton(
                          onPressed: printPDF,
                          child: Text('Print'),
                        ),
                      ],
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
}
