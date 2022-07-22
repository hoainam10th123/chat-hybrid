import 'package:chat_app/models/auth.dart';
import 'package:flutter/material.dart';
import 'home-page.dart';
import 'login_page.dart';


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

  AuthStatus authStatus = AuthStatus.notSignedIn;

  initState() {
    super.initState();

    setState(() {
      authStatus =  AuthStatus.notSignedIn;
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