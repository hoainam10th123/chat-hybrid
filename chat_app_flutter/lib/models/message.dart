class Message {
  int id;
  int senderId;
  String senderUsername;
  String senderPhotoUrl;
  int recipientId;
  String recipientUsername;
  String recipientPhotoUrl;
  String content;
  DateTime dateRead;
  DateTime messageSent;

  Message(
      {this.id,
      this.content,
      this.dateRead,
      this.messageSent,
      this.recipientId,
      this.recipientPhotoUrl,
      this.recipientUsername,
      this.senderId,
      this.senderPhotoUrl,
      this.senderUsername});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      dateRead: json['dateRead'] == null ? new DateTime.now() : DateTime.parse(json['dateRead']),
      messageSent: DateTime.parse(json['messageSent']),
      recipientId: json['recipientId'],
      recipientPhotoUrl: json['recipientPhotoUrl'],
      recipientUsername: json['recipientUsername'],
      senderId: json['senderId'],
      senderPhotoUrl: json['senderPhotoUrl'],
      senderUsername: json['senderUsername']
    );
  }
}
