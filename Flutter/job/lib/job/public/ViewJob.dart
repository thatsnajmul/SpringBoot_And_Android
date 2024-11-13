import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:job/job-application/public/addJobApplication.dart';

class ViewJob extends StatefulWidget {
  @override
  _ViewJobState createState() => _ViewJobState();
}

class _ViewJobState extends State<ViewJob> {
  List<Job> _jobs = [];
  List<Job> _filteredJobs = []; // For search filtering
  bool _isLoading = true;
  String _error = '';
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchJobs();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchJobs() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/getalljobs'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        setState(() {
          _jobs = jsonResponse.map((job) => Job.fromJson(job)).toList();
          _filteredJobs = _jobs; // Initialize filtered list
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

  void _onSearchChanged() {
    setState(() {
      _filteredJobs = _jobs
          .where((job) =>
          job.jobTitle!.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _sortJobs(String criteria) {
    setState(() {
      if (criteria == 'Location') {
        _filteredJobs.sort((a, b) => a.location!.compareTo(b.location!));
      } else if (criteria == 'Salary') {
        _filteredJobs.sort((a, b) => a.salary!.compareTo(b.salary!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Listings'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortJobs,
            itemBuilder: (BuildContext context) {
              return {'Location', 'Salary'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text('Sort by $choice'),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by job title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                ? Center(child: Text(_error))
                : ListView.builder(
              itemCount: _filteredJobs.length,
              itemBuilder: (context, index) {
                final job = _filteredJobs[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      job.jobTitle ?? 'Job Title Unavailable',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(job.companyName ?? 'Company Name Unavailable', style: TextStyle(fontSize: 16)),
                            Text('\$${job.salary?.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text('Location: ${job.location ?? 'Not specified'}', style: TextStyle(fontSize: 14)),
                        SizedBox(height: 8),
                        Text('Job Type: ${job.jobType ?? 'Not specified'}', style: TextStyle(fontSize: 14)),
                        SizedBox(height: 10),
                      ],
                    ),
                    trailing: job.image != null && job.image!.isNotEmpty
                        ? Image.network("http://localhost:8080/uploads/jobs/" + job.image!, width: 50, height: 50, fit: BoxFit.cover)
                        : Icon(Icons.business, size: 50),
                    onTap: () {
                      _showJobDetails(context, job);
                    },
                  ),
                );
              },
            ),
          ),
        ],
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
              Text('Job Title: ${job.jobTitle}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Company: ${job.companyName}', style: TextStyle(fontSize: 16)),
              Text('Location: ${job.location}', style: TextStyle(fontSize: 16)),
              Text('Salary: \$${job.salary?.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16)),
              Text('Job Type: ${job.jobType}', style: TextStyle(fontSize: 16)),
              Text('Position: ${job.position}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              Text('Skills Required:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(job.skills ?? 'No specific skills required'),
              SizedBox(height: 5),
              // Show job logo/image if available
              ElevatedButton(
                onPressed: () {
                  // Navigate to AddJob activity
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddJobApplication()),
                  );
                },
                child: Text('Apply Now'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Job {
  final String? jobTitle;
  final String? description;
  final String? requirements;
  final String? location;
  final double? salary;
  final String? jobType;
  final String? position;
  final String? skills;
  final String? companyName;
  final String? image; // New field for image URL

  Job({
    this.jobTitle,
    this.description,
    this.requirements,
    this.location,
    this.salary,
    this.jobType,
    this.position,
    this.skills,
    this.companyName,
    this.image, // Add image URL field to constructor
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      jobTitle: json['jobTitle'] ?? 'N/A',
      description: json['description'] ?? 'No description available',
      requirements: json['requirements'] ?? 'No requirements specified',
      location: json['location'] ?? 'Location not specified',
      salary: (json['salary'] as num?)?.toDouble() ?? 0.0,
      jobType: json['jobType'] ?? 'Not specified',
      position: json['position'] ?? 'Not specified',
      skills: json['skills'] ?? 'No specific skills required',
      companyName: json['companyName'] ?? 'Company name unavailable',
      image: json['image'] ?? '', // Add the image URL to job object
    );
  }
}
