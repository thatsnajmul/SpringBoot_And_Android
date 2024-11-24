import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;


class ViewCompany extends StatefulWidget {
  @override
  _ViewCompanyState createState() => _ViewCompanyState();
}

class _ViewCompanyState extends State<ViewCompany> {
  String errorMessage = '';
  List<Company> companies = [];
  List<Company> filteredCompanies = [];
  String searchQuery = '';
  String sortOption = 'Name';

  @override
  void initState() {
    super.initState();
    fetchCompanyDetails();
  }

  Future<void> fetchCompanyDetails() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/companies/get-all-companies'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        setState(() {
          companies = jsonResponse.map((data) => Company.fromJson(data)).toList();
          filteredCompanies = companies;
        });
      } else {
        throw Exception('Failed to load companies');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

  void filterCompanies(String query) {
    setState(() {
      searchQuery = query;
      filteredCompanies = companies
          .where((company) => company.companyName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void sortCompanies(String option) {
    setState(() {
      sortOption = option;
      if (option == 'Name') {
        filteredCompanies.sort((a, b) => a.companyName.compareTo(b.companyName));
      } else if (option == 'Employee Size') {
        filteredCompanies.sort((a, b) => int.tryParse(a.employeeSize)?.compareTo(int.tryParse(b.employeeSize) ?? 0) ?? 0);
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Details'),
        backgroundColor: Colors.blueAccent,

      ),
      body: Column(
        children: [
          // Search and Filter Toolbar
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: filterCompanies,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: sortOption,
                  onChanged: (value) {
                    if (value != null) {
                      sortCompanies(value);
                    }
                  },
                  items: ['Name', 'Employee Size']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // Error Message Display
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          // Companies List
          Expanded(
            child: ListView.builder(
              itemCount: filteredCompanies.length,
              itemBuilder: (context, index) {
                final company = filteredCompanies[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.all(10),
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            company.companyImage.isNotEmpty
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                "http://localhost:8080/uploads/companies/" + company.companyImage,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[200],
                              child: Center(child: Text('No Image')),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    company.companyName,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text('Email: ${company.companyEmail}'),
                                  Text('Phone: ${company.companyPhone}'),
                                  Text('Employee Size: ${company.employeeSize}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text('Address: ${company.companyAddress}'),
                        Text('Details: ${company.companyDetails}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Company {
  final String companyName;
  final String companyEmail;
  final String companyPhone;
  final String companyAddress;
  final String companyDetails;
  final String companyImage;
  final String employeeSize;

  Company({
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
      companyName: json['companyName'] ?? '',
      companyEmail: json['companyEmail'] ?? '',
      companyPhone: json['companyPhone'] ?? '',
      companyAddress: json['companyAddress'] ?? '',
      companyDetails: json['companyDetails'] ?? '',
      companyImage: json['companyImage'] ?? '',
      employeeSize: (json['employeeSize'] is int ? json['employeeSize'].toString() : json['employeeSize'] ?? ''),
    );
  }
}



