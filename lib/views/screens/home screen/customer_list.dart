import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:home_dairy/model/customer.dart';
import 'package:home_dairy/services/database.dart';
import 'package:home_dairy/views/screens/auth/text_box.dart';
import 'package:home_dairy/views/screens/home%20screen/add_page.dart';
import 'package:home_dairy/views/screens/home%20screen/detail_page.dart';
import 'package:provider/provider.dart';

class CustomerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final customers = Provider.of<List<Customer>>(context) ?? [];
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: customers.length == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hourglass_empty, size: 70, color: Colors.grey),
                  Text(
                    "You Don't Have Customers",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "you dont have created your customer yet click the below buttion to create new customer",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  FlatButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddPage(),
                      ),
                    ),
                    child: Text("Click Here"),
                  )
                ],
              ),
            )
          : ListView.builder(
              itemCount: customers.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomerTile(customer: customers[index]);
              },
            ),
    );
  }
}

class CustomerTile extends StatelessWidget {
  CustomerTile({
    Key key,
    @required this.customer,
  }) : super(key: key);

  final Customer customer;
  final List<String> choice = ["Edit", "Delete", "View"];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailedPage(
            customer: customer,
          ),
        ),
      ),
      leading: Container(
        height: 80,
        width: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).primaryColor,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(customer.photoUrl),
          ),
        ),
      ),
      title: Text(
        customer.fullName,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text('${customer.quantity} ltr / per days'),
      trailing: PopupMenuButton(
        onSelected: (action) async {
          if (action == "Edit") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddPage(
                  isEdit: true,
                  customer: customer,
                ),
              ),
            );
          } else if (action == "Delete") {
            Reference ref = FirebaseStorage.instance
                .ref()
                .child("${customer.fullName} ${customer.phoneNumber}.jpg");
            await ref.delete();
            await DatabaseServices().deleteCustomer(customer.uid, user.uid);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailedPage(
                  customer: customer,
                ),
              ),
            );
          }
        },
        itemBuilder: (_) {
          return choice.map((action) {
            return PopupMenuItem(
              child: Text(action),
              value: action,
            );
          }).toList();
        },
      ),
    );
  }
}
