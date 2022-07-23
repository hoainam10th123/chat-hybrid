import 'dart:convert';

import 'package:chat_app/helper/primary_button.dart';
import 'package:chat_app/models/UserResponse.dart';
import 'package:chat_app/models/auth.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({required Key key,required this.title, required this.auth,required this.onSignedIn})
      : super(key: key);
  final VoidCallback onSignedIn;
  final String title;
  final AuthASP auth;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  static final formKey = GlobalKey<FormState>();
  final UserLogin _user = UserLogin(userName: '', password: '');
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  FormType _formType = FormType.login;
  String _authHint = '';

  void initState() {
    super.initState();
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      if (_formType == FormType.login) {
        UserResponse resp = await widget.auth.signIn(_user.userName, _user.password);
        if (resp.error == '200') {
          widget.onSignedIn();
          //save local storages
          final SharedPreferences prefs = await _prefs;
          final json = jsonEncode(resp.user!.toJson());
          final _counter = prefs.setString('user', json).then((bool success) {
            return 0;
          });
        } else {
          setState(() {
            _authHint = resp.error!;
          });
        }
      } else {
        /*UserResponse resp = await widget.auth.register(_user);

        if (resp.error == '200') {
          moveToLogin();
        } else {
          setState(() {
            _authHint = resp.error;
          });
        }*/
      }
    }
  }

  void moveToRegister() {
    formKey.currentState!.reset();
    setState(() {
      _formType = FormType.register;
      _authHint = '';
    });
  }

  void moveToLogin() {
    formKey.currentState!.reset();
    setState(() {
      _formType = FormType.login;
      _authHint = '';
    });
  }

  List<Widget> usernameAndPassword() {
    return [
      padded(
          child: TextFormField(
            key: Key('userName'),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Username'),
            autocorrect: false,
            validator: (val) => val!.isEmpty ? 'Username can\'t be empty.' : null,
            onSaved: (val) => _user.userName = val!,
          )),
      padded(
          child: TextFormField(
            key: Key('password'),
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            autocorrect: false,
            validator: (val) => val!.isEmpty ? 'Password can\'t be empty.' : null,
            onSaved: (val) => _user.password = val!,
          )),
    ];
  }

  List<Widget> submitWidgets() {
    switch (_formType) {
      case FormType.login:
        return [
          PrimaryButton(
              key: Key('login'),
              text: 'Login',
              height: 44.0,
              onPressed: validateAndSubmit),
          FlatButton(
              key: Key('need-account'),
              child: Text("Need an account? Register"),
              onPressed: moveToRegister),
        ];
      case FormType.register:
        return [
          PrimaryButton(
              key: Key('register'),
              text: 'Create an account',
              height: 44.0,
              onPressed: validateAndSubmit),
          FlatButton(
              key: Key('need-login'),
              child: Text("Have an account? Login"),
              onPressed: moveToLogin),
        ];
    }
  }

  Widget hintText() {
    return Container(
      //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: Text(_authHint,
            key: Key('hint'),
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //      navigatorKey: widget.auth.alice.getNavigatorKey(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            backgroundColor: Colors.grey[300],
            body: SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      Card(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Form(
                                        key: formKey,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                          children: usernameAndPassword() +
                                              submitWidgets(),
                                        ))),
                              ])),
                      hintText()
                    ])))));
  }

  Widget padded({required Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
