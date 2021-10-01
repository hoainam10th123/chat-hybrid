import 'package:chat_app_flutter/models/auth.dart';
import 'package:flutter/material.dart';
import 'chat-page.dart';

class HomePage extends StatelessWidget {
  final AuthASP auth;
  final VoidCallback onSignOut;

  HomePage({this.auth, this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatPage(key: Key(''), onSignOut: this.onSignOut,),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text("Chats"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            title: Text("Channels"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            title: Text("Profile"),
          ),
        ],
      ),
    );
  }
}
