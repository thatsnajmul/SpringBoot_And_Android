import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewCompany extends StatefulWidget {
  @override
  ViewCompanyState createState() => ViewCompanyState();
}

class ViewCompanyState extends State<ViewCompany> {
  List<dynamic> companies = [];  // Initialize companies as an empty list
  bool isLoading = true;  // State variable to track loading status

  // Fetch company details
  Future<void> fetchCompanyDetails() async {
    final response = await http.get(
      Uri.parse('http://192.168.88.243:8080/api/companies/get-all-companies'),  // Fixed URL
    );

    if (response.statusCode == 200) {
      setState(() {
        companies = json.decode(response.body);  // Parse the response body as a list
        isLoading = false;  // Data has been loaded, stop the loading indicator
      });
    } else {
      setState(() {
        isLoading = false;  // Stop the loading indicator
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Failed to load company details')),
      );
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
          ? Center(child: CircularProgressIndicator())  // Show loading indicator while fetching data
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: companies.isEmpty
            ? Center(child: Text('No companies available'))  // Show if no data was fetched
            : ListView.builder(
          itemCount: companies.length,
          itemBuilder: (context, index) {
            var company = companies[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Company Name: ${company['companyName'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    Text('Email: ${company['companyEmail'] ?? 'N/A'}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Phone: ${company['companyPhone'] ?? 'N/A'}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Details: ${company['companyDetails'] ?? 'N/A'}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Address: ${company['companyAddress'] ?? 'N/A'}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Employee Size: ${company['employeeSize'] ?? 'N/A'}', style: TextStyle(fontSize: 16)),

                    // Show company image if available
                    company['companyImage'] != null && company['companyImage'].isNotEmpty
                        ? Image.network(
                      "http://192.168.88.243:8080/uploads/companies/${company['companyImage']}",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: Center(child: Text('No Image')),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
