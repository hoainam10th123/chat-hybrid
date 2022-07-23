import 'package:chat_app/helper/globals.dart';
import 'package:flutter/material.dart';
import 'conversationList.dart';
import 'package:get/get.dart';
import 'package:chat_app/controller/user-controller.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final VoidCallback onSignOut;

  ChatPage({required Key key, required this.onSignOut}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final userController = Get.put(UserController());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
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
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding:const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
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
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () async {
                    userController.stopHubConnection();
                    Globals.user = null;
                    userController.clearAll();
                    widget.onSignOut();
                    final SharedPreferences prefs = await _prefs;
                    final success = await prefs.remove('user');
                  },
                  child: const Text(
                    'Log out',
                    style: TextStyle(color: Colors.green),
                  ),
                )),
            Obx(
                  () => ListView.builder(
                itemCount: userController.users.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 16),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ConversationList(
                    userName: userController.users[index].userName!,
                    name: userController.users[index].displayName!,
                    imageUrl: userController.users[index].photoUrl?? 'https://localhost:5001/user.png',
                    time: userController.users[index].isOnline == true
                        ? "online"
                        : timeago
                        .format(userController.users[index].lastActive!),
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
