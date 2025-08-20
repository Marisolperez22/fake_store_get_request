import '../../domain/entities/login_response_entity.dart';

class LoginResponse extends LoginResponseEntity {
  LoginResponse({required super.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(token: json['token']);
  }
}
