import 'package:flutter/material.dart';
class TextBox extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final Function validator;

  const TextBox({Key key, this.hintText, this.obscureText, this.controller, this.validator}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:EdgeInsets.symmetric(horizontal: 22,vertical: 5),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius:BorderRadius.circular(9),
        color: Colors.grey[200],
      ),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText:obscureText ?? false ,
        decoration:InputDecoration(
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText ?? ''
        )
      ),
    );
  }
}