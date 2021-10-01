class Member {
  String userName;
  String displayName;
  DateTime lastActive;
  DateTime dayOfBirth;
  String photoUrl;
  List<Photo> photos;
  int unReadMessageCount;
  bool isOnline = false;

  Member(
      {this.userName,
      this.displayName,
      this.lastActive,
      this.dayOfBirth,
      this.photoUrl,
      this.photos,
      this.unReadMessageCount});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
        userName: json['userName'],
        displayName: json['displayName'],
        lastActive: DateTime.parse(json['lastActive']),
        dayOfBirth: DateTime.parse(json['dayOfBirth']),
        photoUrl: json['photoUrl'],
        photos: json['photos'] == null
            ? null
            : List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
        unReadMessageCount: json['unReadMessageCount']);
  }
}

class Photo {
  int id;
  String url;
  bool isMain;
  Photo({this.id, this.url, this.isMain});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(id: json['id'], url: json['url'], isMain: json['isMain']);
  }
}
