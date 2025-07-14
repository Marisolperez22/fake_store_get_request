class User {
  final String username;
  final String password;

  final int? id;
  final Name? name;
  final String? email;
  final String? phone;

  User({
    required this.username,
    required this.password,
    this.id,
    this.name,
    this.email,
    this.phone,
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

class Name {
  final String firstname;
  final String lastname;

  Name({required this.firstname, required this.lastname});

  factory Name.fromJson(Map<String, dynamic> json) =>
      Name(firstname: json["firstname"], lastname: json["lastname"]);

  Map<String, dynamic> toJson() => {
    "firstname": firstname,
    "lastname": lastname,
  };
}
