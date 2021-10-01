class User {
  String userName;
  String token;
  String photoUrl;
  String displayName;
  DateTime lastActive;
  DateTime dayOfBirth;

  User(
      {this.userName,
      this.token,
      this.photoUrl,
      this.displayName,
      this.lastActive,
      this.dayOfBirth});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['userName'],
      token: json['token'],
      photoUrl: json['photoUrl'],
      displayName: json['displayName'],
      lastActive: DateTime.parse(json['lastActive']),
      dayOfBirth: DateTime.parse(json['dayOfBirth'])
    );
  }
}

class UserLogin{
  String userName;
  String password;

  UserLogin({this.userName, this.password});
}
