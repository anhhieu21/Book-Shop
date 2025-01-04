class User {
  late String email;
  late String name;
  late String userClass;
  late String role;
  late DateTime createdAt;
  late DateTime updatedAt;
  late String id;

  User({
    required this.email,
    required this.name,
    required this.userClass,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        name: json["name"],
        userClass: json["class"],
        role: json["role"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "class": userClass,
        "role": role,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "id": id,
      };
}
