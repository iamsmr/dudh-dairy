import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_dairy/model/customer.dart';

class DatabaseServices {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection("User");

  Future updateUser(String uid, String name, String email) async {
    return await userCollection.doc(uid).set({
      "uid": uid,
      "email": email,
      "name": name,
      "pricePerLtr": 70,
    });
  }

  Future updateCustomerAcount({
    String fullName,
    String email,
    String phoneNumber,
    String address,
    String photoUrl,
    String quantity,
    String uid,
  }) async {
    return await userCollection.doc(uid).collection("Customer").add(
      {
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "address": address,
        "photoUrl": photoUrl,
        "customerRecord":[],
        "quantity": quantity,
      },
    );
  }
  Future deleteCustomer(String docId,String uid) async{
     print("delete");
     return await userCollection.doc(uid).collection("Customer").doc(docId).delete();
  }

  Future updateCustomerInfo({
    String fullName,
    String email,
    String phoneNumber,
    String address,
    String photoUrl,
    String quantity,
    String uid,
    String docUid,
  }) async {
    return await userCollection.doc(uid).collection("Customer").doc(docUid).update(
      {
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "address": address,
        "photoUrl": photoUrl,
        "quantity": quantity,
      },
    );
  }


  List<Customer> listOfCustomer(QuerySnapshot snapshot) {
    try{
      return snapshot != null
        ? snapshot.docs.map((customer) {
            return Customer(
              uid: customer.id,
              email: customer["email"] ?? '',
              fullName: customer["fullName"] ?? '',
              phoneNumber: customer["phoneNumber"] ?? '',
              photoUrl: customer["photoUrl"] ?? '',
              address: customer["address"] ?? '',
              quantity: customer["quantity"] ?? '',
              record: customer["customerRecord"] ?? [],
            );
          }).toList()
        : null;

    }catch(e){
      print(e.message);
      return null;
    }


    
  }

  Stream<List<Customer>> getCustomer(uid) {
    return userCollection
        .doc(uid)
        .collection("Customer")
        .snapshots()
        .map(listOfCustomer);
  }
}
