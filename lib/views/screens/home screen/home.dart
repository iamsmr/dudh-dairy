import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_dairy/model/customer.dart';
import 'package:home_dairy/services/auth_services.dart';
import 'package:home_dairy/services/database.dart';
import 'package:home_dairy/views/screens/home%20screen/add_page.dart';
import 'package:home_dairy/views/screens/home%20screen/customer_list.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<List<Customer>>.value(
      value: DatabaseServices().getCustomer(user.uid),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dudh dairy"),
          actions: [
            IconButton(onPressed: () => null, icon: Icon(Icons.settings)),
            IconButton(
              onPressed: () => AuthServices().signOut(),
              icon: Icon(Icons.exit_to_app),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => AddPage(isEdit: false))),
          child: Icon(Icons.add),
        ),
        body: CustomerList(),
      ),
    );
  }
}
