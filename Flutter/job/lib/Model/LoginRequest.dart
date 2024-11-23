class LoginRequest {
  final String name;
  final String username;
  final String password;

  LoginRequest({required this.name,required this.username, required this.password});

  Map<String, dynamic> toJson() => {
    'name': name,
    'username': username,
    'password': password,
  };
}

