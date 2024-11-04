// user_model.dart
import 'package:flutter/material.dart';

class User {
  String name;
  String email;
  String password;
  String cell;
  String address;
  String gender;
  String role; // New field
  String image; // New field
  String dob; // New field
  bool active; // New field
  bool isLock; // New field

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.cell,
    required this.address,
    required this.gender,
    required this.role,
    required this.image,
    required this.dob,
    required this.active,
    required this.isLock,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'cell': cell,
      'address': address,
      'gender': gender,
      'role': role,
      'image': image,
      'dob': dob,
      'active': active,
      'isLock': isLock,
    };
  }
}

