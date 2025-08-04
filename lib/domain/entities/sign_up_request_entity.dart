class SignUpRequestEntity {
  final String email;
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;

  SignUpRequestEntity({
    required this.email,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });
}
