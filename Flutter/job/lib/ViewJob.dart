import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewJob extends StatefulWidget {
  @override
  _ViewJobState createState() => _ViewJobState();
}

class _ViewJobState extends State<ViewJob> {
  List<Job> _jobs = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
   _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/getalljobs')); // Replace with your API URL
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        setState(() {
          _jobs = jsonResponse.map((job) => Job.fromJson(job)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load jobs';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Listings'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text(_error))
          : ListView.builder(
        itemCount: _jobs.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            elevation: 4,
            child: ListTile(
              title: Text(_jobs[index].jobTitle),
              subtitle: Text(_jobs[index].companyName),
              onTap: () {
                _showJobDetails(context, _jobs[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _showJobDetails(BuildContext context, Job job) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(job.jobTitle, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Company: ${job.companyName}', style: TextStyle(fontSize: 18)),
              Text('Location: ${job.location}', style: TextStyle(fontSize: 16)),
              Text('Salary: \$${job.salary.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
              Text('Job Type: ${job.jobType}', style: TextStyle(fontSize: 16)),
              Text('Position: ${job.position}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(job.description),
              SizedBox(height: 10),
              Text('Requirements:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(job.requirements),
              SizedBox(height: 10),
              Text('Skills Required:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(job.skills),
            ],
          ),
        );
      },
    );
  }
}

class Job {
  final String jobTitle;
  final String description;
  final String requirements;
  final String location;
  final double salary;
  final String jobType; // e.g., Full-time, Part-time, Contract
  final String position; // e.g., Junior, Senior, Intern
  final String skills; // Comma-separated list of required skills
  final String companyName;

  Job({
    required this.jobTitle,
    required this.description,
    required this.requirements,
    required this.location,
    required this.salary,
    required this.jobType,
    required this.position,
    required this.skills,
    required this.companyName,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      jobTitle: json['job_title'],
      description: json['description'],
      requirements: json['requirements'],
      location: json['location'],
      salary: (json['salary'] as num).toDouble(), // Convert to double
      jobType: json['job_type'],
      position: json['position'],
      skills: json['skills'],
      companyName: json['company_name'],
    );
  }
}
