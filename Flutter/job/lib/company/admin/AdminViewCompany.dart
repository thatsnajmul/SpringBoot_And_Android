import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'UpdateCompany.dart'; // Ensure this file exists and is properly implemented

class AdminViewCompany extends StatefulWidget {
  @override
  _AdminViewCompanyState createState() => _AdminViewCompanyState();
}

class _AdminViewCompanyState extends State<AdminViewCompany> {
  List<dynamic> companies = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchCompanies(); // Fetch companies when the widget is initialized
  }

  // Fetch companies from the API
  Future<void> fetchCompanies() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/companies/get-all-companies'));

      if (response.statusCode == 200) {
        setState(() {
          companies = json.decode(response.body); // Decode the response and set the companies list
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load companies. Status: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
      print("Error fetching companies: $e");
    }
  }

  // Delete company by ID
  Future<void> deleteCompany(String companyId) async {
    try {
      final response = await http.delete(Uri.parse('http://localhost:8080/api/companies/delete/$companyId'));

      if (response.statusCode == 200 || response.statusCode == 204) {
        // If status code is 200 or 204, assume deletion is successful
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Company deleted successfully!')));
        fetchCompanies(); // Refresh the company list
      } else {
        // Handle failure case
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete company. Status: ${response.statusCode}')));
        print('Failed to delete company: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      print('Error deleting company: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Companies'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator if data is empty
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : companies.isEmpty
          ? Center(child: Text('No companies available.'))
          : ListView.builder(
        itemCount: companies.length,
        itemBuilder: (context, index) {
          final company = companies[index];
          final companyId = company['companyId'].toString();

          return CompanyCard(
            company: company,
            onEdit: () {
              // Pass companyId to UpdateCompany screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateCompany(companyId: companyId),
                ),
              ).then((_) => fetchCompanies()); // Refresh companies on return
            },
            onDelete: () async {
              bool? shouldDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Company'),
                  content: Text('Are you sure you want to delete this company?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false); // Cancels the action
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true); // Confirms the action
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );

              if (shouldDelete == true) {
                deleteCompany(companyId); // Pass companyId to delete
              }
            },
          );
        },
      ),
    );
  }
}

class CompanyCard extends StatelessWidget {
  final dynamic company;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CompanyCard({
    required this.company,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              company['companyName'] ?? 'N/A',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Email: ${company['companyEmail'] ?? 'N/A'}'),
            Text('Phone: ${company['companyPhone'] ?? 'N/A'}'),
            Text('Details: ${company['companyDetails'] ?? 'N/A'}'),
            Text('Address: ${company['companyAddress'] ?? 'N/A'}'),
            Text('Employee: ${company['employeeSize'] ?? 'N/A'}'),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onEdit,
                  child: Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
