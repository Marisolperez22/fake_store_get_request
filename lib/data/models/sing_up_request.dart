import '../../domain/entities/sign_up_request_entity.dart';

class SignupRequest extends SignUpRequestEntity {
  SignupRequest({
    required super.email,
    required super.phone,
    required super.username,
    required super.password,
    required super.lastName,
    required super.firstName,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'phone': phone,
    'username': username,
    'password': password,
    'name': {'firstname': firstName, 'lastname': lastName},
  };
}
