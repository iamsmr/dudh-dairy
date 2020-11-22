class Customer {
  String fullName;
  String email;
  String phoneNumber;
  String address;
  String quantity;
  String photoUrl;
  List<String> record;
  String uid;

  Customer({
    this.uid,
    this.fullName,
    this.email,
    this.photoUrl,
    this.phoneNumber,
    this.quantity,
    this.record,
    this.address,
  });
}
