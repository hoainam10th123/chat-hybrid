import 'dart:io';

import 'package:chat_app_flutter/views/root_page.dart';
import 'package:flutter/material.dart';
import 'models/auth.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
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
      home: RootPage(auth: new AuthASP())
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}