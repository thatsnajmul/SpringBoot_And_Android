import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

import '../model/JobApplication.dart';

class JobApplicationService {
  final String baseUrl = "http://localhost:8080/api/job-application";  // Replace with your API base URL

  // Fetch all job applications
  Future<List<JobApplication>> fetchJobApplications() async {
    final response = await http.get(Uri.parse('$baseUrl/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => JobApplication.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load job applications");
    }
  }

  // Fetch job application by ID
  Future<JobApplication> fetchJobApplicationById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return JobApplication.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load job application");
    }
  }

  // Save new job application with image upload
  Future<void> saveJobApplication(JobApplication jobApplication, File imageFile) async {
    Dio dio = Dio();
    String filename = imageFile.path.split('/').last;

    FormData formData = FormData.fromMap({
      'jobApplication': json.encode(jobApplication.toJson()),
      'image': await MultipartFile.fromFile(imageFile.path, filename: filename),
    });

    final response = await dio.post('$baseUrl/save', data: formData);

    if (response.statusCode != 200) {
      throw Exception("Failed to save job application");
    }
  }

  // Update job application with image upload
  Future<void> updateJobApplication(int id, JobApplication jobApplication, File imageFile) async {
    Dio dio = Dio();
    String filename = imageFile.path.split('/').last;

    FormData formData = FormData.fromMap({
      'jobApplication': json.encode(jobApplication.toJson()),
      'image': await MultipartFile.fromFile(imageFile.path, filename: filename),
    });

    final response = await dio.put('$baseUrl/$id', data: formData);

    if (response.statusCode != 200) {
      throw Exception("Failed to update job application");
    }
  }

  // Delete job application by ID
  Future<void> deleteJobApplication(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete job application");
    }
  }
}
