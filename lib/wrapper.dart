import 'package:flutter/material.dart';
import 'package:home_dairy/views/screens/auth/authentication.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_dairy/views/screens/home screen/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user != null){
      return Home();
    }
    return Authentication();
  }
}
