class User {
  BigInt id;
  String username;
  String email;

  User({required this.id, required this.username, required this.email});

  User.fromJson(Map<String, dynamic> json)
      : id = BigInt.from(json["id"] ?? 0),
        username = json["username"],
        email = json["email"];
}
