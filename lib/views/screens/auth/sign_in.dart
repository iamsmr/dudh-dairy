import 'package:flutter/material.dart';
import 'package:home_dairy/views/screens/auth/validator.dart';
import 'package:home_dairy/views/screens/auth/text_box.dart';
import 'package:home_dairy/services/auth_services.dart';
import 'package:home_dairy/views/loading.dart';

class Login extends StatefulWidget {
  final Function switchScreen;
  const Login({Key key, this.switchScreen}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return loading
        ? Loading()
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 130),
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 50),
                        TextBox(
                          controller: email,
                          hintText: 'Email',
                          validator: (String val) =>
                              Validator.emailValidator(val),
                        ),
                        TextBox(
                          controller: password,
                          hintText: 'Password',
                          obscureText: true,
                          validator: (String val) =>
                              Validator.passwordValidator(val),
                        ),
                        SizedBox(height: 50),
                        SizedBox(
                          height: 55,
                          width: double.infinity,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            onPressed: () async {
                              if (formKey.currentState.validate()) {
                                setState(() => loading = true);
                                final result = await AuthServices()
                                    .signInWithEmailAndPassword(
                                  email.text.trim().toLowerCase(),
                                  password.text.trim().toLowerCase(),
                                );
                                if (result == null) {
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              }
                            },
                            child:
                                Text('Login', style: TextStyle(fontSize: 21)),
                            textColor: Colors.white,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Dont have an Acount',
                              style: TextStyle(fontSize: 18),
                            ),
                            TextButton(
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              onPressed: () => widget.switchScreen(),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
