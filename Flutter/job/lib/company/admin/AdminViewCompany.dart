import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'UpdateCompany.dart';

class AdminViewCompany extends StatefulWidget {
  @override
  _AdminViewCompanyState createState() => _AdminViewCompanyState();
}

class _AdminViewCompanyState extends State<AdminViewCompany> {
  List<dynamic> companies = [];

  Future<void> fetchCompanies() async {
    final response = await http.get(Uri.parse('http://192.168.88.243:8080/api/companies/get-all-companies'));

    if (response.statusCode == 200) {
      setState(() {
        companies = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: Failed to load companies')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Companies')),
      body: companies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: companies.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(companies[index]['companyName']),
            subtitle: Text(companies[index]['companyEmail']),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateCompany(companyId: companies[index]['id']),
                  ),
                ).then((_) => fetchCompanies());
              },
            ),
          );
        },
      ),
    );
  }
}
