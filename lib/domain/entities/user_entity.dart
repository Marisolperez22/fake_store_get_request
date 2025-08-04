import '../../data/models/name.dart';

class UserEntity {
  final String username;
  final String password;
  final int? id;
  final Name? name;
  final String? email;
  final String? phone;

  UserEntity({
    required this.username,
    required this.password,
    this.id,
    this.name,
    this.email,
    this.phone,
  });
}
