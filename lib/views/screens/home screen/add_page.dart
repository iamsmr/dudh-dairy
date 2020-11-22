import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:home_dairy/model/customer.dart';
import 'package:home_dairy/services/database.dart';
import 'package:home_dairy/views/loading.dart';
import 'package:home_dairy/views/screens/auth/text_box.dart';
import 'package:home_dairy/views/screens/auth/validator.dart';
import 'package:image_picker/image_picker.dart';

class AddPage extends StatefulWidget {
  final bool isEdit;
  final Customer customer;

  const AddPage({Key key, this.isEdit, this.customer}) : super(key: key);
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  List<String> quantityList = ['1/4', "1/2", '1', "2", "3", "4", "5", "6"];
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  String photoUrl;
  bool loading = false;
  File _image;
  String quantity;
  void pickFromGallery() async {
    try {
      // ignore: deprecated_member_use
      File image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _image = image);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void pickFromCamera() async {
    try {
      // ignore: deprecated_member_use
      File image = await ImagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() => _image = image);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(title: Text("Add Customer")),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextBox(
                        hintText: 'Full Name',
                        controller: fullName,
                        validator: (val) =>
                            val.isEmpty ? " Enter Full name" : null,
                      ),
                      TextBox(
                        hintText: "Email",
                        controller: email,
                        validator: (val) => Validator.emailValidator(val),
                      ),
                      TextBox(
                        hintText: "Phone Number",
                        controller: phoneNumber,
                        validator: (val) => Validator.phoneNumberValidator(val),
                      ),
                      TextBox(
                        hintText: "Address",
                        controller: address,
                        validator: (val) =>
                            val.isEmpty ? " Enter Address" : null,
                      ),
                      Container(
                        height: 120,
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => pickFromGallery(),
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.grey,
                                  child: _image != null
                                      ? Image.file(_image, fit: BoxFit.cover)
                                      : Icon(Icons.image, size: 45),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => pickFromCamera(),
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.grey,
                                  child: _image != null
                                      ? Image.file(_image, fit: BoxFit.cover)
                                      : Icon(Icons.camera_alt, size: 45),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 5),
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Colors.grey[200],
                        ),
                        child: DropdownButtonFormField(
                          icon: Icon(Icons.arrow_drop_down_circle, size: 30),
                          iconEnabledColor: Theme.of(context).primaryColor,
                          validator: (val) =>
                              val == null ? "Select Quantity" : null,
                          decoration: InputDecoration(
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Quantity",
                          ),
                          items: quantityList.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text("$item ltr/day"),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => quantity = val),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              try {
                                Reference ref =
                                    FirebaseStorage.instance.ref().child(
                                          "${fullName.text} ${phoneNumber.text}.jpg",
                                        );
                                final uploadTask = await ref.putFile(_image);
                                var dowurl =
                                    await uploadTask.ref.getDownloadURL();
                                photoUrl = dowurl.toString();
                                await DatabaseServices().updateCustomerAcount(
                                  fullName: fullName.text.trim(),
                                  address: address.text.trim(),
                                  email: email.text.trim(),
                                  phoneNumber: phoneNumber.text.trim(),
                                  photoUrl: photoUrl,
                                  quantity: quantity.trim(),
                                  uid: user.uid,
                                );
                              } catch (e) {
                                setState(() => loading = false);
                                print(e.message);
                              }
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'Create Customer Page',
                            style: TextStyle(fontSize: 21),
                          ),
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
