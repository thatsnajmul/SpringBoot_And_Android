import 'package:flutter/material.dart';
import '../../model/Job.dart';
import '../../service/JobService.dart';
import 'JobDetailsPage.dart';

class JobListPage extends StatefulWidget {
  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  late Future<List<Job>> futureJobs;
  final JobService jobService = JobService();

  @override
  void initState() {
    super.initState();
    futureJobs = jobService.getAllJobs();  // Fetch jobs when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Listings"),  // Adjusted the title for clarity
      ),
      body: FutureBuilder<List<Job>>(
        future: futureJobs,  // Fetch data asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // Loading indicator while waiting for data
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));  // Show error message if there's an issue
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No jobs available"));  // No data available
          } else {
            List<Job> jobs = snapshot.data!;  // Access the list of jobs once data is available
            return ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(jobs[index].jobTitle),  // Display job title
                  subtitle: Text(jobs[index].companyName),  // Display company name
                  onTap: () {
                    // Navigate to the Job Details Page when a job is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailsPage(job: jobs[index]),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
