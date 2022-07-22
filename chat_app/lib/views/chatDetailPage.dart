import 'package:chat_app/controller/message-controller.dart';
import 'package:chat_app/controller/user-controller.dart';
import 'package:chat_app/helper/globals.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatDetailPage extends StatefulWidget {
  String userName;
  ChatDetailPage({Key? key, required this.userName}) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final messagesController = Get.put(MessagesController());
  final UserController userController = Get.find();
  String content = "";

  @override
  void initState() {
    // TODO: implement initState
    print("initState of ChatDetailPage");
    messagesController.createHubConnection(widget.userName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    messagesController.clearMessage();
                    messagesController.stopHubConnection();
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                Obx(() => CircleAvatar(
                  backgroundImage: NetworkImage(
                      userController.userSelected.value.photoUrl ??
                          "https://randomuser.me/api/portraits/men/1.jpg"),
                  maxRadius: 20,
                )),
                const SizedBox(
                  width: 12,
                ),
                Obx(() => Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        userController.userSelected.value.displayName!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        timeago.format(
                            userController.userSelected.value.lastActive!),
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                )),
                const Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Obx(() => SingleChildScrollView(
            child: ListView.builder(
              itemCount: messagesController.messages.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 10, bottom: 10),
                  child: Obx(() => Align(
                    alignment: (messagesController
                        .messages[index].recipientUsername ==
                        Globals.user!.userName
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (messagesController.messages[index]
                            .recipientUsername ==
                            Globals.user!.userName
                            ? Colors.grey.shade200
                            : Colors.blue[200]),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        messagesController.messages[index].content!,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  )),
                );
              },
            ),
          )),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (text) {
                        content = text;
                      },
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      messagesController.sendMessageToClient(
                          userController.userSelected.value.userName!, content);
                      messagesController.addMessage(Message(
                          content: content,
                          recipientUsername:
                          userController.userSelected.value.userName,
                          dateRead: DateTime.now(),
                          messageSent: DateTime.now()));
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
