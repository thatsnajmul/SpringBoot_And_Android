class User {
  final String name;
  late final String email; // This parameter is required

  User({required this.name, required this.email, required String password}); // Constructor requires both

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      password: '',
    );
  }

  get password => null;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}

