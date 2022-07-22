import 'package:chat_app/controller/user-controller.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'chatDetailPage.dart';
import 'package:get/get.dart';

class ConversationList extends StatelessWidget{
  String userName;
  String name;
  String imageUrl;
  String time;
  int unreadMessageCount;
  final UserController c = Get.find();


  ConversationList({required this.userName,required this.name,required this.imageUrl,required this.time,required this.unreadMessageCount});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        c.selectedUser(userName);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailPage(userName: userName),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                    maxRadius: 30,
                  ),
                  const SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(name, style: const TextStyle(fontSize: 16),),
                          const SizedBox(height: 6,),
                          Text(time,style: TextStyle(fontSize: 13,color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Badge(
              badgeContent: _getBadgeText(),
            )
          ],
        ),
      ),
    );
  }

  Widget _getBadgeText(){
    if(unreadMessageCount > 0){
      return Text(unreadMessageCount.toString(), style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold));
    }
    return Text("");
  }
}
