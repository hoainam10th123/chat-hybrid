import 'package:chat_app/models/user.dart';

class Globals {
  static User? user;
}

const serverName = "10.0.2.2"; //10.0.2.2 for mobile or localhost for desktop app
const urlBase = "https://$serverName:5001/";
const hubUrl = "https://$serverName:5001/hubs/";