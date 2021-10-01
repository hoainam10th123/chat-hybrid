import 'dart:convert';
import 'dart:io';
import 'package:chat_app_flutter/controller/message-controller.dart';
import 'package:chat_app_flutter/helper/globals.dart';
import 'package:chat_app_flutter/models/member.dart';
import 'package:chat_app_flutter/models/message.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:signalr_client/signalr_client.dart';

class UserController extends GetxController {
  var users = List<Member>().obs;
  var userSelected = Member().obs;
  final messagesController = Get.put(MessagesController());
  HubConnection _hubConnection;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchUsers();
  }

  createHubConnection() {
    if (_hubConnection == null) {
      _hubConnection = HubConnectionBuilder()
          .withUrl(hubUrl + "presence",
          options: HttpConnectionOptions(
              accessTokenFactory: () async => Globals.user.token))
          .build();

      _hubConnection.onclose((error) => print("Connection Closed"));

      if (_hubConnection.state != HubConnectionState.Connected) {
        _hubConnection
            .start()
            .catchError((e) => {
          print("PresenceService at Start: "+ e.toString())
        });
      }

      _hubConnection.on("UserIsOnline", _userIsOnline);
      _hubConnection.on("UserIsOffline", _userIsOffline);
      _hubConnection.on("GetOnlineUsers", _getOnlineUsers);
      _hubConnection.on("NewMessageReceived", _newMessageReceived);
    }
  }

  void _userIsOnline(List<Object> parameters) {
    final String username = parameters[0];
    for(int i = 0; i < users.length; i++){
      if(users[i].userName == username){
        users[i].isOnline = true;
        users[i] = users[i];
        break;
      }
    }
  }

  void _userIsOffline(List<Object> parameters) {
    final String username = parameters[0];
    for(int i = 0; i < users.length; i++){
      if(users[i].userName == username){
        users[i].isOnline = false;
        users[i] = users[i];
        break;
      }
    }
  }

  void _getOnlineUsers(List<Object> parameters) {
    final userNames = parameters[0] as List<dynamic>;
    userNames.forEach((element) {
      //print('${element}');
      int index = users.indexWhere((f) => f.userName == element.toString());
      if(index != -1){
        if(users[index].userName == element.toString()){
          users[index].isOnline = true;
          users[index] = users[index];
        }
      }
    });
  }

  void _newMessageReceived(List<Object> parameters) {
    final message = new Map<String, dynamic>.from(parameters[0]);
    final mess = Message.fromJson(message);

    if(mess.senderUsername == userSelected.value.userName){
      messagesController.addMessage(mess);
    }

    int index = users.indexWhere((f) => f.userName == mess.senderUsername);//message['senderUsername']
    if(index != -1){
      users[index].unReadMessageCount++;
      users[index] = users[index];
    }
  }

  stopHubConnection(){
    _hubConnection.stop().catchError((e) => {
      print("PresenceService at Stop: "+ e.toString())
    });
    _hubConnection = null;
  }

  void clearAll(){
    users.clear();
  }

  void selectedUser(String userName){
    int index = users.indexWhere((f) => f.userName == userName);
    if(index != -1){
      users[index].unReadMessageCount = 0;
      userSelected.value = users[index];
      users[index] = users[index];
    }
  }

  void fetchUsers() async {
    try {
      String authorization = 'Bearer ' + Globals.user.token;
      final response = await http.get(URL_BASE+"api/User", headers: {HttpHeaders.authorizationHeader: authorization});

      if(response.statusCode == 200){
        final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
        users.value = parsed.map<Member>((json) => Member.fromJson(json)).toList();
      }
    } catch (e) {
      print(e.message);
    }
  }
}