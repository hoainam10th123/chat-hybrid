import 'package:chat_app_flutter/models/user.dart';

class Globals {
  static User user;
}

const SERVER_NAME = "10.0.2.2";
const URL_BASE = "https://$SERVER_NAME:5001/";

const hubUrl = "https://$SERVER_NAME:5001/hubs/";