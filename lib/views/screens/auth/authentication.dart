import 'package:flutter/material.dart';
import 'package:home_dairy/views/screens/auth/register.dart';
import 'package:home_dairy/views/screens/auth/sign_in.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool toggleScreen = true;
  void switchScreen() => setState(() => toggleScreen = !toggleScreen);

  @override
  Widget build(BuildContext context) => toggleScreen
      ? Login(switchScreen: switchScreen)
      : CreateAcount(switchScreen: switchScreen);
}
