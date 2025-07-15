class SignupRequest {
  final String email;
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;

  SignupRequest({
    required this.email,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'username': username,
    'password': password,
    'name': {
      'firstname': firstName,
      'lastname': lastName,
    },
    'phone': phone,
  };
}