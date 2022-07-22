class User {
  String userName;
  String token;
  String photoUrl;
  String displayName;
  DateTime lastActive;
  DateTime dayOfBirth;

  User(
      {required this.userName, required this.token, required this.photoUrl, required this.displayName, required this.lastActive, required this.dayOfBirth});

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
  UserLogin({required this.userName, required this.password});
}
