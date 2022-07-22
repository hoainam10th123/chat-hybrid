import 'package:chat_app/helper/globals.dart';
import 'package:chat_app/models/message.dart';
import 'package:get/get.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/signalr_client.dart';

class MessagesController extends GetxController {
  var messages = <Message>[].obs;
  HubConnection? _hubConnection;

  createHubConnection(String otherUsername) {
    if (_hubConnection == null) {
      _hubConnection = HubConnectionBuilder()
          .withUrl("${hubUrl}message?user=$otherUsername",
          options: HttpConnectionOptions(
              accessTokenFactory: () async => Globals.user!.token))
          .build();

      _hubConnection!.onclose(({Exception? error}) => print(error.toString()));

      if (_hubConnection!.state != HubConnectionState.Connected) {
        _hubConnection!
            .start()
            .catchError((e) => {
          print("PresenceService at Start: $e")
        });
        print("Start hub at MessagesController: $otherUsername");
      }

      _hubConnection!.on("ReceiveMessageThread", _receiveMessageThread);
    }
  }

  void _receiveMessageThread(List<Object> parameters) {
    final _messages = parameters[0] as List<dynamic>;

    _messages.forEach((element) {
      var mess = Message.fromJson(element);
      messages.add(mess);
    });
  }

  void sendMessageToClient(String userNameTo, String content){
    _hubConnection!.invoke("SendMessage", args: <Object>[
      {'RecipientUsername': userNameTo, 'Content':content}
    ]);
  }

  void addMessage(Message message){
    messages.add(message);
  }

  void clearMessage(){
    messages.clear();
  }

  stopHubConnection(){
    if(_hubConnection != null){
      _hubConnection!.stop();
      _hubConnection = null;
    }
  }

}