import 'package:chat_app_flutter/helper/globals.dart';
import 'package:flutter/material.dart';
import 'conversationList.dart';
import 'package:get/get.dart';
import 'package:chat_app_flutter/controller/user-controller.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatPage extends StatefulWidget {
  final VoidCallback onSignOut;

  ChatPage({Key key, this.onSignOut}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final userController = Get.put(UserController());

  @override
  void initState() {
    // TODO: implement initState
    userController.fetchUsers();
    userController.createHubConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Conversations",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    userController.stopHubConnection();
                    Globals.user = null;
                    userController.clearAll();
                    widget.onSignOut();
                  },
                  child: Text(
                    'Log out',
                    style: TextStyle(color: Colors.green),
                  ),
                )),
            Obx(
              () => ListView.builder(
                itemCount: userController.users.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ConversationList(
                    userName: userController.users[index].userName,
                    name: userController.users[index].displayName,
                    imageUrl: userController.users[index].photoUrl,
                    time: userController.users[index].isOnline == true
                        ? "online"
                        : timeago
                            .format(userController.users[index].lastActive),
                    unreadMessageCount:
                        userController.users[index].unReadMessageCount,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
