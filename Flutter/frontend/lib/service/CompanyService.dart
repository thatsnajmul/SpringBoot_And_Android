import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../model/Company.dart';

class CompanyService {
  final String apiUrl = 'http://localhost:8080/api/company';  // Replace with your API URL

  // Get all companies
  Future<List<Company>> getAllCompanies() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Company.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load companies');
      }
    } catch (e) {
      throw Exception('Failed to load companies: $e');
    }
  }

  // Get a single company by id
  Future<Company> getCompanyById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      return Company.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load company');
    }
  }

  // Add a new company
  Future<Company> saveCompany(Company company, XFile? image) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }

      request.fields['companyName'] = company.companyName;
      request.fields['companyImage'] = company.companyImage;
      request.fields['companyDetails'] = company.companyDetails;
      request.fields['companyEmail'] = company.companyEmail;
      request.fields['companyAddress'] = company.companyAddress;
      request.fields['companyPhone'] = company.companyPhone;
      request.fields['employeeSize'] = company.employeeSize.toString();

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        return Company.fromJson(json.decode(responseData));
      } else {
        throw Exception('Failed to add company');
      }
    } catch (e) {
      throw Exception('Failed to save company: $e');
    }
  }

  // Update an existing company
  Future<Company> updateCompany(int id, Company company, XFile? image) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$apiUrl/$id'));

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }

      request.fields['companyName'] = company.companyName;
      request.fields['companyImage'] = company.companyImage;
      request.fields['companyDetails'] = company.companyDetails;
      request.fields['companyEmail'] = company.companyEmail;
      request.fields['companyAddress'] = company.companyAddress;
      request.fields['companyPhone'] = company.companyPhone;
      request.fields['employeeSize'] = company.employeeSize.toString();

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        return Company.fromJson(json.decode(responseData));
      } else {
        throw Exception('Failed to update company');
      }
    } catch (e) {
      throw Exception('Failed to update company: $e');
    }
  }

  // Delete company
  Future<void> deleteCompany(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete company');
    }
  }
}
