class User {
  final String username;
  final String email; // This parameter is required

  User({required this.username, required this.email, required String password}); // Constructor requires both

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'], password: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
    };
  }
}

