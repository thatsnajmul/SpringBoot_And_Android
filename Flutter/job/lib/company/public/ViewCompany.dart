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
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: company['companyImage'] != null && company['companyImage'].isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "http://192.168.88.243:8080/uploads/companies/${company['companyImage']}",
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                )
                    : Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: Icon(Icons.business, color: Colors.grey),
                ),
                title: Text(
                  company['companyName'] ?? 'N/A',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'Email: ${company['companyEmail'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      'Phone: ${company['companyPhone'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      'Employee Size: ${company['employeeSize'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                isThreeLine: true, // Allow for 3 lines in subtitle
                trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                onTap: () {
                  // Add your navigation or other onTap functionality here
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
