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
      final response = await http.get(Uri.parse('http://localhost:8080/getalljobs'));
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
      final response = await http.delete(Uri.parse('http://localhost:8080/deletejob/$id'));
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
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      isThreeLine: true,
                      leading: job.image != null && job.image!.isNotEmpty
                          ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImageView(imageUrl: 'http://localhost:8080/uploads/jobs/' + job.image!),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            'http://localhost:8080/uploads/jobs/' + job.image!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                          : Icon(Icons.business_center, size: 60, color: Colors.grey),
                      title: Text(
                        job.jobTitle ?? 'Job Title Unavailable',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4.0),
                          Text(
                            'Company: ${job.companyName ?? 'Company not specified'}',
                            style: TextStyle(color: Colors.black54),
                          ),
                          Text(
                            'Location: ${job.location ?? 'Location not specified'}',
                            style: TextStyle(color: Colors.black54),
                          ),
                          Text(
                            'Salary: \$${job.salary?.toStringAsFixed(2) ?? 'Not specified'}',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateJob(id: job.id),
                                ),
                              ).then((_) => _fetchJobs());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            ),
                            child: Text('Edit', style: TextStyle(fontSize: 14)),
                          ),
                          SizedBox(width: 8.0), // Space between the buttons
                          ElevatedButton(
                            onPressed: () => _deleteJob(job.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            ),
                            child: Text('Delete', style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
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

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;
  const FullScreenImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Job Image')),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.1,
          maxScale: 1.5,
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}

class Job {
  final String id;
  final String? jobTitle;
  final String? description;
  final String? requirements;
  final String? location;
  final double? salary;
  final String? jobType;
  final String? position;
  final String? skills;
  final String? companyName;
  final String? image;

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
    this.image,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id']?.toString() ?? '',
      jobTitle: json['jobTitle'] ?? 'N/A',
      description: json['description'] ?? 'No description available',
      requirements: json['requirements'] ?? 'No requirements specified',
      location: json['location'] ?? 'Location not specified',
      salary: (json['salary'] as num?)?.toDouble() ?? 0.0,
      jobType: json['jobType'] ?? 'Not specified',
      position: json['position'] ?? 'Not specified',
      skills: json['skills'] ?? 'No specific skills required',
      companyName: json['companyName'] ?? 'Company name unavailable',
      image: json['image'] ?? '',
    );
  }
}
