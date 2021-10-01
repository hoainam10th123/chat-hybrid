import 'package:chat_app_flutter/controller/user-controller.dart';
import 'package:chat_app_flutter/helper/primary_button.dart';
import 'package:chat_app_flutter/models/UserResponse.dart';
import 'package:chat_app_flutter/models/auth.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth, this.onSignedIn})
      : super(key: key);
  final VoidCallback onSignedIn;
  final String title;
  final AuthASP auth;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  static final formKey = new GlobalKey<FormState>();
  UserLogin _user = new UserLogin();

  FormType _formType = FormType.login;
  String _authHint = '';

  void initState() {
    super.initState();
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
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
        } else {
          setState(() {
            _authHint = resp.error;
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
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      _authHint = '';
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
      _authHint = '';
    });
  }

  List<Widget> usernameAndPassword() {
    return [
      padded(
          child: new TextFormField(
            key: new Key('userName'),
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(labelText: 'Username'),
            autocorrect: false,
            validator: (val) => val.isEmpty ? 'Username can\'t be empty.' : null,
            onSaved: (val) => _user.userName = val,
          )),
      padded(
          child: new TextFormField(
            key: new Key('password'),
            decoration: new InputDecoration(labelText: 'Password'),
            obscureText: true,
            autocorrect: false,
            validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
            onSaved: (val) => _user.password = val,
          )),
    ];
  }

  List<Widget> submitWidgets() {
    switch (_formType) {
      case FormType.login:
        return [
          new PrimaryButton(
              key: new Key('login'),
              text: 'Login',
              height: 44.0,
              onPressed: validateAndSubmit),
          new FlatButton(
              key: new Key('need-account'),
              child: new Text("Need an account? Register"),
              onPressed: moveToRegister),
        ];
      case FormType.register:
        return [
          new PrimaryButton(
              key: new Key('register'),
              text: 'Create an account',
              height: 44.0,
              onPressed: validateAndSubmit),
          new FlatButton(
              key: new Key('need-login'),
              child: new Text("Have an account? Login"),
              onPressed: moveToLogin),
        ];
    }
    return null;
  }

  Widget hintText() {
    return new Container(
      //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: new Text(_authHint,
            key: new Key('hint'),
            style: new TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //      navigatorKey: widget.auth.alice.getNavigatorKey(),
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text(widget.title),
            ),
            backgroundColor: Colors.grey[300],
            body: new SingleChildScrollView(
                child: new Container(
                    padding: const EdgeInsets.all(16.0),
                    child: new Column(children: [
                      new Card(
                          child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Container(
                                    padding: const EdgeInsets.all(16.0),
                                    child: new Form(
                                        key: formKey,
                                        child: new Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                          children: usernameAndPassword() +
                                              submitWidgets(),
                                        ))),
                              ])),
                      hintText()
                    ])))));
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
