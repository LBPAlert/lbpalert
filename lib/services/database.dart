import 'package:lbpalert/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final DatabaseReference users = FirebaseDatabase.instance.ref("users");

  Future UpdateUserData(String firstname, String lastname, String phoneNum,
      String address) async {
    return await users
        .child(uid)
        .set({
          'firstname': firstname,
          'lastname': lastname,
          'phone_number': phoneNum,
          "address": address,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  // get streams
  FirebaseUserData _userDataFromSnapshot(DatabaseEvent event) {
    return FirebaseUserData(
        uid: uid,
        phoneNumber: (event.snapshot.value as dynamic)['phone_number'],
        address: (event.snapshot.value as dynamic)['address'],
        firstname: (event.snapshot.value as dynamic)['firstname'],
        lastname: (event.snapshot.value as dynamic)['lastname']);
  }

  Stream<FirebaseUserData> get userData {
    return users.child(uid).onChildChanged.map(_userDataFromSnapshot);
  }
}
