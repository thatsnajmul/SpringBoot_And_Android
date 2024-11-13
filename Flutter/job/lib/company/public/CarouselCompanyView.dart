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

          // If image URL is not null and does not start with 'http', you may need to add a base URL
          if (companyImage != null && !companyImage.startsWith('http')) {
            companyImage = 'http://localhost:8080/images/companies/$companyImage'; // Adjust your base URL
          }

          return Card(
            elevation: 4.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              contentPadding: EdgeInsets.all(10.0),
              leading: companyImage != null
                  ? CachedNetworkImage(
                imageUrl: companyImage,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )
                  : Icon(Icons.business, size: 60, color: Colors.grey),
              title: Text(
                company['companyName'] ?? 'N/A',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${company['companyEmail'] ?? 'N/A'}'),
                  Text('Phone: ${company['companyPhone'] ?? 'N/A'}'),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                // Handle onTap event (e.g., navigate to a detailed view)
                // You can navigate to a detailed page with more info
              },
            ),
          );
        },
      ),
    );
  }
}
