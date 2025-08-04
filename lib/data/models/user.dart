import 'name.dart';
import '../../domain/entities/user_entity.dart';

class User extends UserEntity {
  User({
    required super.username,
    required super.password,
    super.id,
    super.name,
    super.email,
    super.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    phone: json["phone"],
    username: json["username"],
    password: json["password"],
    name: Name.fromJson(json["name"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "phone": phone,
    "username": username,
    "password": password,
    "name": name?.toJson(),
  };
}
