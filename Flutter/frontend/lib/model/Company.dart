class Company {
  int? id;
  String companyName;
  String companyImage;
  String companyDetails;
  String companyEmail;
  String companyAddress;
  String companyPhone;
  int employeeSize;
  String image;  // To store the image URL or filename

  Company({
    this.id,
    required this.companyName,
    required this.companyImage,
    required this.companyDetails,
    required this.companyEmail,
    required this.companyAddress,
    required this.companyPhone,
    required this.employeeSize,
    required this.image,
  });

  // Convert a Company object into a map for API interaction
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'companyImage': companyImage,
      'companyDetails': companyDetails,
      'companyEmail': companyEmail,
      'companyAddress': companyAddress,
      'companyPhone': companyPhone,
      'employeeSize': employeeSize,
      'image': image,
    };
  }

  // Create a Company object from JSON
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      companyName: json['companyName'],
      companyImage: json['companyImage'],
      companyDetails: json['companyDetails'],
      companyEmail: json['companyEmail'],
      companyAddress: json['companyAddress'],
      companyPhone: json['companyPhone'],
      employeeSize: json['employeeSize'],
      image: json['image'],
    );
  }
}
