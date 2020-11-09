import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User user) => json.encode(user.toJson());

class User {
  int id;
  String username;
  String password;
  String email;

  User({this.id, this.username, this.password,this.email});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        id: parsedJson['id'],
        username: parsedJson['username'],
        password: parsedJson['password'],
        email: parsedJson['email']);
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "username" : username,
    "password" : password,
    "email" : email,
  };

  @override
  String toString() {
    return 'User{id: $id, username: $username, password: $password, email: $email}';
  }

}
