class Job {
  int? id;
  String jobTitle;
  String description;
  String requirements;
  String location;
  double maxSalary;
  double minSalary;
  String companyName;
  String companyEmail;
  String companyPhone;
  String jobType;
  String position;
  String skills;
  String image;

  Job({
    this.id,
    required this.jobTitle,
    required this.description,
    required this.requirements,
    required this.location,
    required this.maxSalary,
    required this.minSalary,
    required this.companyName,
    required this.companyEmail,
    required this.companyPhone,
    required this.jobType,
    required this.position,
    required this.skills,
    required this.image,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      jobTitle: json['jobTitle'],
      description: json['description'],
      requirements: json['requirements'],
      location: json['location'],
      maxSalary: json['maxSalary'],
      minSalary: json['minSalary'],
      companyName: json['companyName'],
      companyEmail: json['companyEmail'],
      companyPhone: json['companyPhone'],
      jobType: json['jobType'],
      position: json['position'],
      skills: json['skills'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobTitle': jobTitle,
      'description': description,
      'requirements': requirements,
      'location': location,
      'maxSalary': maxSalary,
      'minSalary': minSalary,
      'companyName': companyName,
      'companyEmail': companyEmail,
      'companyPhone': companyPhone,
      'jobType': jobType,
      'position': position,
      'skills': skills,
      'image': image,
    };
  }
}
