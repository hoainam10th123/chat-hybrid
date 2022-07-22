import 'package:chat_app/models/auth.dart';
import 'package:flutter/material.dart';
import 'chat-page.dart';

class HomePage extends StatelessWidget {
  final AuthASP auth;
  final VoidCallback onSignOut;

  HomePage({required this.auth, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatPage(key: Key(''), onSignOut: this.onSignOut,),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chats'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            label: 'Channels'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
              label: 'Profile'
          ),
        ],
      ),
    );
  }
}
