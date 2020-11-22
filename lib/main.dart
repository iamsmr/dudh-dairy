import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_dairy/views/loading.dart';
import 'package:home_dairy/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:home_dairy/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamProvider<User>.value(
              value: AuthServices().user,
              child: Wrapper(),
            );
          }
          return Loading();
        },
      ),
    );
  }
}
