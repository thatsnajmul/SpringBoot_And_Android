import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../model/Job.dart';

class JobService {
  final String baseUrl = "http://localhost:8080/api/job"; // Change it to your actual backend URL.

  // Fetch all jobs
  Future<List<Job>> getAllJobs() async {
    final response = await http.get(Uri.parse('$baseUrl/'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => Job.fromJson(job)).toList();
    } else {
      throw Exception("Failed to load jobs");
    }
  }

  // Fetch job by ID
  Future<Job> getJobById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Job.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load job");
    }
  }

  // Save job with image
  Future<void> saveJob(Job job, File? imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/save'));

    // Add Job Details
    request.fields['job'] = json.encode(job.toJson());

    if (imageFile != null) {
      // Add image to the request
      var image = await http.MultipartFile.fromPath('image', imageFile.path);
      request.files.add(image);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Job added successfully');
    } else {
      throw Exception('Failed to add job');
    }
  }

  // Update job with image
  Future<void> updateJob(int id, Job job, File? imageFile) async {
    var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/$id'));

    // Add Job Details
    request.fields['job'] = json.encode(job.toJson());

    if (imageFile != null) {
      var image = await http.MultipartFile.fromPath('image', imageFile.path);
      request.files.add(image);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Job updated successfully');
    } else {
      throw Exception('Failed to update job');
    }
  }

  // Delete job
  Future<void> deleteJob(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      print('Job deleted successfully');
    } else {
      throw Exception('Failed to delete job');
    }
  }

  // Search jobs by company name
  Future<List<Job>> searchJobsByCompany(String companyName) async {
    final response = await http.get(Uri.parse('$baseUrl/h/searchjob?companyName=$companyName'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => Job.fromJson(job)).toList();
    } else {
      throw Exception("Failed to search jobs");
    }
  }
}
