import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'UpdateCompany.dart'; // Ensure UpdateCompany.dart is imported

class Company {
  final String companyId;
  final String companyName;
  final String companyEmail;
  final String companyPhone;
  final String companyAddress;
  final String companyDetails;
  final String companyImage;
  final String employeeSize;

  Company({
    required this.companyId,
    required this.companyName,
    required this.companyEmail,
    required this.companyPhone,
    required this.companyAddress,
    required this.companyDetails,
    required this.companyImage,
    required this.employeeSize,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyId: json['_id'] ?? '', // Assuming _id is used as companyId
      companyName: json['companyName'] ?? '',
      companyEmail: json['companyEmail'] ?? '',
      companyPhone: json['companyPhone'] ?? '',
      companyAddress: json['companyAddress'] ?? '',
      companyDetails: json['companyDetails'] ?? '',
      companyImage: json['companyImage'] ?? '',
      employeeSize: (json['employeeSize'] is int
          ? json['employeeSize'].toString()
          : json['employeeSize'] ?? ''),
    );
  }
}

class CompanyViewByCurrentUser extends StatefulWidget {
  @override
  _CompanyViewByCurrentUserState createState() => _CompanyViewByCurrentUserState();
}

class _CompanyViewByCurrentUserState extends State<CompanyViewByCurrentUser> {
  List<Company> companies = [];
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
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          companies = jsonResponse.map((companyData) => Company.fromJson(companyData)).toList();
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
    }
  }

  // Delete company by ID
  Future<void> deleteCompany(String companyId) async {
    try {
      final response = await http.delete(Uri.parse('http://localhost:8080/api/companies/delete/$companyId'));

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Company deleted successfully!')));
        fetchCompanies(); // Refresh the company list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete company. Status: ${response.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Companies')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : companies.isEmpty
          ? Center(child: Text('No companies available.'))
          : ListView.builder(
        itemCount: companies.length,
        itemBuilder: (context, index) {
          final company = companies[index];

          return CompanyTile(
            company: company,
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateCompany(companyId: company.companyId),
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
                        Navigator.pop(context, false);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );

              if (shouldDelete == true) {
                deleteCompany(company.companyId); // Pass companyId to delete
              }
            },
          );
        },
      ),
    );
  }
}

class CompanyTile extends StatelessWidget {
  final Company company;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CompanyTile({
    required this.company,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: company.companyImage.isNotEmpty
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            "http://localhost:8080/uploads/companies/" + company.companyImage,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        )
            : Icon(Icons.business, size: 50, color: Colors.grey), // Fallback for missing image
        title: Text(
          company.companyName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${company.companyEmail}', style: TextStyle(color: Colors.grey[600])),
            Text('Phone: ${company.companyPhone}', style: TextStyle(color: Colors.grey[600])),
            Text('Size: ${company.employeeSize} employees', style: TextStyle(color: Colors.grey[600])),
            Text('Address: ${company.companyAddress}', style: TextStyle(color: Colors.grey[600])),
            Text('Details: ${company.companyDetails}', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onEdit,
              icon: Icon(Icons.edit, color: Colors.blue),
              tooltip: 'Edit Company',
            ),
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.delete, color: Colors.red),
              tooltip: 'Delete Company',
            ),
          ],
        ),
        onTap: () {
          // Optionally, you can navigate to a detail view on tap
        },
      ),
    );
  }
}
