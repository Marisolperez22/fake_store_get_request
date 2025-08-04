import '../../domain/entities/login_response_entity.dart';

class LoginResponse extends LoginResponseEntity {
  LoginResponse({required super.token, required super.userId});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(token: json['token'], userId: json["userId"] ?? 0);
  }
}
