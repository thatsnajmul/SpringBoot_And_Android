import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// Keeping the method name the same as requested
Future<void> addJobWithImage({
  required String jobTitle,
  required String description,
  required String requirements,
  required String location,
  required double salary,
  required String jobType,
  required String position,
  required String skills,
  required String companyName,
  File? imageFile, // The image file to upload
}) async {
  // Create the Job model data
  Map<String, dynamic> jobData = {
    'jobDetails': json.encode({
      'jobTitle': jobTitle,
      'description': description,
      'requirements': requirements,
      'location': location,
      'salary': salary,
      'jobType': jobType,
      'position': position,
      'skills': skills,
      'companyName': companyName,
    }),
  };

  var uri = Uri.parse('http://localhost:8080/addjob'); // Update with your API URL
  var request = http.MultipartRequest('POST', uri);

  // Attach the job data
  request.fields['jobDetails'] = jobData['jobDetails'];

  // Attach the image file if provided
  if (imageFile != null) {
    var multipartImage = await http.MultipartFile.fromPath('image', imageFile.path);
    request.files.add(multipartImage);
  }

  try {
    var response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Job added successfully");
    } else {
      print("Failed to add job: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
  }
}
