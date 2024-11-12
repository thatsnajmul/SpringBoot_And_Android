import 'dart:ffi';

class JobApplication {
  int? id;
  String applicantName;
  String image;
  double expectedSalary;
  String applicantEmail;
  String applicantPhone;
  String resumeLink;
  String applicationDate;
  String applicationStatus;
  String coverLetter;
  String jobTitleApplied;
  String skills;
  String jobTypeApplied;
  String locationPreference;
  String positionLevel;
  int jobId;

  JobApplication({
    this.id,
    required this.applicantName,
    required this.image,
    required this.expectedSalary,
    required this.applicantEmail,
    required this.applicantPhone,
    required this.resumeLink,
    required this.applicationDate,
    required this.applicationStatus,
    required this.coverLetter,
    required this.jobTitleApplied,
    required this.skills,
    required this.jobTypeApplied,
    required this.locationPreference,
    required this.positionLevel,
    required this.jobId,
  });

  // Convert JSON to JobApplication object
  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'],
      applicantName: json['applicantName'],
      image: json['image'],
      expectedSalary: json['expectedSalary'],
      applicantEmail: json['applicantEmail'],
      applicantPhone: json['applicantPhone'],
      resumeLink: json['resumeLink'],
      applicationDate: json['applicationDate'],
      applicationStatus: json['applicationStatus'],
      coverLetter: json['coverLetter'],
      jobTitleApplied: json['jobTitleApplied'],
      skills: json['skills'],
      jobTypeApplied: json['jobTypeApplied'],
      locationPreference: json['locationPreference'],
      positionLevel: json['positionLevel'],
      jobId: json['jobId'],
    );
  }

  // Convert JobApplication object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'applicantName': applicantName,
      'image': image,
      'expectedSalary': expectedSalary,
      'applicantEmail': applicantEmail,
      'applicantPhone': applicantPhone,
      'resumeLink': resumeLink,
      'applicationDate': applicationDate,
      'applicationStatus': applicationStatus,
      'coverLetter': coverLetter,
      'jobTitleApplied': jobTitleApplied,
      'skills': skills,
      'jobTypeApplied': jobTypeApplied,
      'locationPreference': locationPreference,
      'positionLevel': positionLevel,
      'jobId': jobId,
    };
  }
}
