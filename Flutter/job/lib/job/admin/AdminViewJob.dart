import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:job/job/admin/UpdateJob.dart';


class AdminViewJob extends StatefulWidget {
  @override
  _ViewJobState createState() => _ViewJobState();
}

class _ViewJobState extends State<AdminViewJob> {
  List<Job> _jobs = [];
  List<Job> _filteredJobs = [];
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
      final response = await http.get(Uri.parse('http://192.168.88.243:8080/getalljobs'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        setState(() {
          _jobs = jsonResponse.map((job) => Job.fromJson(job)).toList();
          _filteredJobs = _jobs;
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
          .where((job) => job.jobTitle!.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  Future<void> _deleteJob(String id) async {
    try {
      final response = await http.delete(Uri.parse('http://192.168.88.243:8080/deletejob/$id'));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Job deleted successfully!')));
        _fetchJobs(); // Refresh the job list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete job')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Job Title: ${job.jobTitle}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Company: ${job.companyName}', style: TextStyle(fontSize: 16)),
                        Text('Location: ${job.location}', style: TextStyle(fontSize: 16)),
                        Text('Salary: \$${job.salary?.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                        Text('Job Type: ${job.jobType}', style: TextStyle(fontSize: 16)),
                        Text('Position: ${job.position}', style: TextStyle(fontSize: 16)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateJob(id: job.id),
                                  ),
                                ).then((_) => _fetchJobs()); // Refresh jobs on return
                              },
                              child: Text('Edit'),
                            ),
                            ElevatedButton(
                              onPressed: () => _deleteJob(job.id), // Call the delete function
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text('Delete'),
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
    );
  }
}

class Job {
  final String id; // Ensure this matches the job ID field from your API
  final String? jobTitle;
  final String? description;
  final String? requirements;
  final String? location;
  final double? salary;
  final String? jobType;
  final String? position;
  final String? skills;
  final String? companyName;

  Job({
    required this.id,
    this.jobTitle,
    this.description,
    this.requirements,
    this.location,
    this.salary,
    this.jobType,
    this.position,
    this.skills,
    this.companyName,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id']?.toString() ?? '', // Convert id to String if it's not already
      jobTitle: json['jobTitle'] ?? 'N/A',
      description: json['description'] ?? 'No description available',
      requirements: json['requirements'] ?? 'No requirements specified',
      location: json['location'] ?? 'Location not specified',
      salary: (json['salary'] as num?)?.toDouble() ?? 0.0,
      jobType: json['jobType'] ?? 'Not specified',
      position: json['position'] ?? 'Not specified',
      skills: json['skills'] ?? 'No specific skills required',
      companyName: json['companyName'] ?? 'Company name unavailable',
    );
  }
}
