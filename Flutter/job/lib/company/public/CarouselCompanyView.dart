import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';  // Import CachedNetworkImage for caching images

class CarouselCompanyView extends StatefulWidget {
  @override
  _CarouselCompanyViewState createState() => _CarouselCompanyViewState();
}

class _CarouselCompanyViewState extends State<CarouselCompanyView> {
  List<dynamic> companies = [];
  bool isLoading = true;

  // Fetch company details
  Future<void> fetchCompanyDetails() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/companies/get-all-companies'));
    if (response.statusCode == 200) {
      setState(() {
        companies = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: Failed to load company details')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCompanyDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Company Details')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : companies.isEmpty
          ? Center(child: Text('No companies available'))
          : ListView.builder(
        itemCount: companies.length,
        itemBuilder: (context, index) {
          var company = companies[index];

          // Extract image URL
          String? companyImage = company['companyImages']?.isNotEmpty == true
              ? company['companyImages'][0] // Assuming this is a valid URL
              : null;

          // Debug: Print the image URL
          print('Image URL: $companyImage');

          // If image URL is not null and does not start with 'http', you may need to add a base URL
          if (companyImage != null && !companyImage.startsWith('http')) {
            companyImage = 'http://localhost:8080/images/companies/$companyImage'; // Adjust your base URL
          }

          return Card(
            elevation: 4.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display company image using CachedNetworkImage
                  companyImage != null
                      ? CachedNetworkImage(
                    imageUrl: companyImage,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      height: 120,
                      child: Center(child: Text('Failed to load image')),
                    ),
                  )
                      : Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: Center(child: Text('No Image')),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Company: ${company['companyName'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('Email: ${company['companyEmail'] ?? 'N/A'}', style: TextStyle(fontSize: 14)),
                  Text('Phone: ${company['companyPhone'] ?? 'N/A'}', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
