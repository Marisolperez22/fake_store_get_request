import 'package:fake_store_get_request/domain/entities/name_entity.dart';

class Name extends NameEntity {
  Name({required super.firstname, required super.lastname});

  factory Name.fromJson(Map<String, dynamic> json) =>
      Name(firstname: json["firstname"], lastname: json["lastname"]);

  Map<String, dynamic> toJson() => {
    "firstname": firstname,
    "lastname": lastname,
  };
}
