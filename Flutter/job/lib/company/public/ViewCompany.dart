import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Company Model to hold the company data
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
      companyImage: json['companyImage']?.toString() ?? '',
      employeeSize: (json['employeeSize'] is int ? json['employeeSize'].toString() : json['employeeSize'] ?? ''),
    );
  }

  get companyId => null;
}

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
    fetchCompanyDetails(); // Fetch company details on initialization
  }

  // Fetch companies data from API
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

  // Filter companies based on the search query
  void filterCompanies(String query) {
    setState(() {
      searchQuery = query;
      filteredCompanies = companies
          .where((company) => company.companyName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Sort companies based on selected option
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

  // Generate PDF for companies
  Future<pw.Document> generatePDF() async {
    final pdf = pw.Document();

    // Add pages for each company
    for (var company in filteredCompanies) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Company Name: ${company.companyName}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Text('Email: ${company.companyEmail}'),
                pw.Text('Phone: ${company.companyPhone}'),
                pw.Text('Employee Size: ${company.employeeSize}'),
                pw.Text('Company Address: ${company.companyAddress}'),
                pw.Text('Company Details: ${company.companyDetails}'),
                pw.SizedBox(height: 20),
              ],
            );
          },
        ),
      );
    }
    return pdf;
  }

  // Method to download the PDF
  Future<void> generateAndDownloadPDF() async {
    try {
      final pdf = await generatePDF();
      final output = await getTemporaryDirectory();
      final filePath = '${output.path}/company_details.pdf';
      final file = File(filePath);

      // Save the PDF file to disk
      await file.writeAsBytes(await pdf.save());

      // Share the PDF
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'company_details.pdf');
    } catch (e) {
      setState(() {
        errorMessage = 'Error saving or sharing PDF: $e';
      });
    }
  }

  // Method to print the PDF
  Future<void> printPDF() async {
    try {
      final pdf = await generatePDF();
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (e) {
      setState(() {
        errorMessage = 'Error printing PDF: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            // Search Bar
            TextField(
              onChanged: filterCompanies,
              decoration: InputDecoration(
                labelText: 'Search Companies',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            // Sort Dropdown
            DropdownButton<String>(
              value: sortOption,
              onChanged: (value) {
                if (value != null) {
                  sortCompanies(value);
                }
              },
              items: <String>['Name', 'Employee Size']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // List of Companies
            Expanded(
              child: ListView.separated(
                itemCount: filteredCompanies.length,
                itemBuilder: (context, index) {
                  final company = filteredCompanies[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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
                              SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      company.companyName,
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      'Email: ${company.companyEmail}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    Text(
                                      'Phone: ${company.companyPhone}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      'Employee Size: ${company.employeeSize}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    SizedBox(height: 8.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Address: ${company.companyAddress}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Details: ${company.companyDetails}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),


                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
