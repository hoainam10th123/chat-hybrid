import 'package:flutter/material.dart';
import 'package:chat_app/views/root_page.dart';
import 'models/auth.dart';
import 'dart:io';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Chat app',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RootPage(key: Key('RootPage'), auth: AuthASP())
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}