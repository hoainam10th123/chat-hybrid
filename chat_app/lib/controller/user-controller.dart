import 'dart:convert';
import 'dart:io';
import 'package:chat_app/controller/message-controller.dart';
import 'package:chat_app/helper/globals.dart';
import 'package:chat_app/models/member.dart';
import 'package:chat_app/models/message.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/signalr_client.dart';

class UserController extends GetxController {
  var users = <Member>[].obs;
  var userSelected = Member(unReadMessageCount: 0).obs;
  final messagesController = Get.put(MessagesController());
  HubConnection? _hubConnection;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchUsers();
  }

  createHubConnection() {
    if (_hubConnection == null) {
      _hubConnection = HubConnectionBuilder()
          .withUrl("${hubUrl}presence",
              options: HttpConnectionOptions(
                  accessTokenFactory: () async => Globals.user!.token))
          .build();

      _hubConnection!.onclose(({Exception? error}) => _myFunction(error));

      if (_hubConnection!.state != HubConnectionState.Connected) {
        _hubConnection!.start().catchError(
            (e) => {print("PresenceService at Start: " + e.toString())});
      }

      _hubConnection!.on("UserIsOnline", _userIsOnline);
      _hubConnection!.on("UserIsOffline", _userIsOffline);
      _hubConnection!.on("GetOnlineUsers", _getOnlineUsers);
      _hubConnection!.on("NewMessageReceived", _newMessageReceived);
    }
  }

  _myFunction(Exception? error) => print(error.toString());

  void _userIsOnline(List<Object> parameters) {
    final String username = parameters[0].toString();
    for (int i = 0; i < users.length; i++) {
      if (users[i].userName == username) {
        users[i].isOnline = true;
        users[i] = users[i];
        break;
      }
    }
  }

  void _userIsOffline(List<Object> parameters) {
    final String username = parameters[0].toString();
    for (int i = 0; i < users.length; i++) {
      if (users[i].userName == username) {
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
      if (index != -1) {
        if (users[index].userName == element.toString()) {
          users[index].isOnline = true;
          users[index] = users[index];
        }
      }
    });
  }

  void _newMessageReceived(List<Object> parameters) {
    //final message = Map<String, dynamic>.from(parameters[0] as Map<String, dynamic>);
    final message = parameters[0] as Map<String, dynamic>;
    final mess = Message.fromJson(message);

    if (mess.senderUsername == userSelected.value.userName) {
      messagesController.addMessage(mess);
    }

    int index = users.indexWhere(
        (f) => f.userName == mess.senderUsername); //message['senderUsername']
    if (index != -1) {
      users[index].unReadMessageCount++;
      users[index] = users[index];
    }
  }

  stopHubConnection() {
    _hubConnection!
        .stop()
        .catchError((e) => {print("PresenceService at Stop: " + e.toString())});
    _hubConnection = null;
  }

  void clearAll() {
    users.clear();
  }

  void selectedUser(String userName) {
    int index = users.indexWhere((f) => f.userName == userName);
    if (index != -1) {
      users[index].unReadMessageCount = 0;
      userSelected.value = users[index];
      users[index] = users[index];
    }
  }

  void fetchUsers() async {
    try {
      String authorization = 'Bearer ${Globals.user!.token}';
      final url = Uri.parse("${urlBase}api/User");
      final response = await http
          .get(url, headers: {HttpHeaders.authorizationHeader: authorization});

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
        users.value =
            parsed.map<Member>((json) => Member.fromJson(json)).toList();
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
