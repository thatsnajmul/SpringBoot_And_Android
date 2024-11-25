import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String jobsUrl = 'http://localhost:8080/getalljobs';
  final String jobApplicationsUrl = 'http://localhost:8080/api/job-applications/getall';
  final String companiesUrl = 'http://localhost:8080/api/companies/get-all-companies';

  Future<int> getTotalJobs() async {
    final response = await http.get(Uri.parse(jobsUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.length;
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  

  Future<int> getTotalJobApplications() async {
    final response = await http.get(Uri.parse(jobApplicationsUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.length;
    } else {
      throw Exception('Failed to load job applications');
    }
  }

  Future<int> getTotalCompanies() async {
    final response = await http.get(Uri.parse(companiesUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.length;
    } else {
      throw Exception('Failed to load companies');
    }
  }
}
