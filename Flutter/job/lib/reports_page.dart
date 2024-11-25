import 'package:flutter/material.dart';
import 'Service/api_service.dart';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final ApiService _apiService = ApiService();
  int? totalJobs;
  int? totalJobApplications;
  int? totalCompanies;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    try {
      final jobs = await _apiService.getTotalJobs();
      final jobApplications = await _apiService.getTotalJobApplications();
      final companies = await _apiService.getTotalCompanies();

      setState(() {
        totalJobs = jobs;
        totalJobApplications = jobApplications;
        totalCompanies = companies;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
    }
  }

  Widget buildReportCard(String title, int value, Color color) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              value.toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: value / 100, // Example percentage
              backgroundColor: Colors.grey[300],
              color: color,
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports Page'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Report Date: ${DateTime.now().toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            buildReportCard('Total Jobs', totalJobs ?? 0, Colors.blue),
            SizedBox(height: 10),
            buildReportCard('Total Job Applications', totalJobApplications ?? 0, Colors.green),
            SizedBox(height: 10),
            buildReportCard('Total Companies', totalCompanies ?? 0, Colors.orange),
          ],
        ),
      ),
    );
  }
}
