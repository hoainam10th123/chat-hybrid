import 'dart:convert';
import 'package:get/get.dart';
import 'package:chat_app/models/auth.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';
import '../controller/user-controller.dart';
import '../helper/globals.dart';
import 'home-page.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootPage extends StatefulWidget {
  RootPage({required Key key, required this.auth}) : super(key: key);
  final AuthASP auth;

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  AuthStatus authStatus = AuthStatus.notSignedIn;
  final userController = Get.put(UserController());

  initState() {
    super.initState();
    /*setState(() {
      authStatus =  AuthStatus.notSignedIn;
    });*/
    //read from local storages
    final user = _prefs.then((SharedPreferences prefs) {
      var json = prefs.getString('user');
      if(json == null){
        _updateAuthStatus(AuthStatus.notSignedIn);
        return null;
      }
      Map<String, dynamic> userJson = jsonDecode(json);
      final tempUser = User.fromJson(userJson);
      Globals.user = tempUser;
      userController.createHubConnection();
      _updateAuthStatus(AuthStatus.signedIn);
      return tempUser;
    });
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return LoginPage(
          key: Key('loginPage'),
          title: 'Login',
          auth: widget.auth,
          onSignedIn: () => _updateAuthStatus(AuthStatus.signedIn),
        );
      case AuthStatus.signedIn:
        return HomePage(
            auth: widget.auth,
            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn)
        );
    }
  }
}