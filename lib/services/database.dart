import 'package:lbpalert/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final DatabaseReference _users = FirebaseDatabase.instance.ref("users");

  Future createUserData(String firstname, String lastname, String phoneNum,
      String address, String profilePic) async {
    return await _users
        .child(uid)
        .set({
          'firstname': firstname,
          'lastname': lastname,
          'phone_number': phoneNum,
          "address": address,
          "profile_pic": profilePic,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future updateUserData(String firstname, String lastname, String phoneNum,
      String address) async {
    return await _users
        .child(uid)
        .update({
          'firstname': firstname,
          'lastname': lastname,
          'phone_number': phoneNum,
          "address": address,
        })
        .then((value) => print("User Data Updated"))
        .catchError((error) => print("Failed to update user data: $error"));
  }

  Future updateProfilePic(String profilePic) async {
    return await _users
        .child(uid)
        .update({
          'profile_pic': profilePic,
        })
        .then((value) => print("Profile Pic Updated"))
        .catchError((error) => print("Failed to update profile Pic: $error"));
  }

  // get streams
  FirebaseUserData _userDataFromSnapshot(DatabaseEvent event) {
    return FirebaseUserData(
        uid: uid,
        firstname: (event.snapshot.value as dynamic)['firstname'],
        lastname: (event.snapshot.value as dynamic)['lastname'],
        phoneNumber: (event.snapshot.value as dynamic)['phone_number'],
        address: (event.snapshot.value as dynamic)['address'],
        profilePic: (event.snapshot.value as dynamic)['profile_pic']);
  }

  Stream<FirebaseUserData> get userData {
    return _users.child(uid).onChildChanged.map(_userDataFromSnapshot);
  }

  DatabaseReference get getChild {
    return _users.child(uid);
  }

  String getFirstName(DatabaseEvent event) {
    return '${(event.snapshot.value as dynamic)['firstname']}!';
  }

  String getLastName(DatabaseEvent event) {
    return '${(event.snapshot.value as dynamic)['lastname']}';
  }

  String getFullName(DatabaseEvent event) {
    return '${(event.snapshot.value as dynamic)['firstname']} ${(event.snapshot.value as dynamic)['lastname']}';
  }

  String getPhoneNum(DatabaseEvent event) {
    return '${(event.snapshot.value as dynamic)['phone_number']}';
  }

  String getAddress(DatabaseEvent event) {
    return '${(event.snapshot.value as dynamic)['address']}';
  }

  String getPic(DatabaseEvent event) {
    return '${(event.snapshot.value as dynamic)['profile_pic']}';
  }
}
