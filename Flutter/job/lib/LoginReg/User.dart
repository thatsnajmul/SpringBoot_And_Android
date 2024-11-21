import 'dart:convert';

class User {
  int? id;
  String? name;
  String? email;
  String? password;
  String? cell;
  String? address;
  String? dob; // Date as String, you can format it to a DateTime later if needed
  String? gender;
  String? image;
  bool? active;
  bool? isLock;
  String? role;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.cell,
    this.address,
    this.dob,
    this.gender,
    this.image,
    this.active,
    this.isLock,
    this.role,
  });

  // Factory method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      cell: json['cell'],
      address: json['address'],
      dob: json['dob'],
      gender: json['gender'],
      image: json['image'],
      active: json['active'],
      isLock: json['isLock'],
      role: json['role'],
    );
  }

  // Method to convert a User instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'cell': cell,
      'address': address,
      'dob': dob,
      'gender': gender,
      'image': image,
      'active': active,
      'isLock': isLock,
      'role': role,
    };
  }
}
