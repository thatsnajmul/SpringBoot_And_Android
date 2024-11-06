import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart'; // Only import from carousel_slider

class CarouselCompanyView extends StatefulWidget {
  @override
  CarouselCompanyViewState createState() => CarouselCompanyViewState();
}

class CarouselCompanyViewState extends State<CarouselCompanyView> {
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
                    // Carousel slider for company images
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200,  // Height of the carousel
                        autoPlay: true,  // Enable auto play
                        enlargeCenterPage: true,  // Center the current page
                        aspectRatio: 16 / 9,  // Aspect ratio of carousel
                        viewportFraction: 0.8,  // Adjust the item size
                      ),
                      items: company['companyImages']?.map<Widget>((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList() ??
                          [Center(child: Text('No images available'))],  // Placeholder if no images are found
                    ),
                    SizedBox(height: 8),
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
