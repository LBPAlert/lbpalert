import 'dart:async';
import 'package:lbpalert/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

class UserDatabaseService {
  final String uid;
  UserDatabaseService({required this.uid});

  final DatabaseReference _users = FirebaseDatabase.instance.ref("users");

  Future createUserData(
      String firstname,
      String lastname,
      String phoneNum,
      String address,
      String profilePic,
      int painTarget,
      String deviceID) async {
    return await _users
        .child(uid)
        .set({
          'firstname': firstname,
          'lastname': lastname,
          'phone_number': phoneNum,
          "address": address,
          "profile_pic": profilePic,
          "pain_target": painTarget,
          "device_id": deviceID,
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

  Future updatePainTarget(int painTarget) async {
    return await _users
        .child(uid)
        .update({
          'pain_target': painTarget,
        })
        .then((value) => print("Pain Target Updated"))
        .catchError((error) => print("Failed to update pain target: $error"));
  }

  Future updateDeviceID(String deviceID) async {
    return await _users
        .child(uid)
        .update({
          'device_id': deviceID,
        })
        .then((value) => print("Device ID Updated"))
        .catchError((error) => print("Failed to update device ID: $error"));
  }

  // get streams
  FirebaseUserData _userDataFromSnapshot(DatabaseEvent event) {
    return FirebaseUserData(
        uid: uid,
        firstname: (event.snapshot.value as dynamic)['firstname'],
        lastname: (event.snapshot.value as dynamic)['lastname'],
        phoneNumber: (event.snapshot.value as dynamic)['phone_number'],
        address: (event.snapshot.value as dynamic)['address'],
        profilePic: (event.snapshot.value as dynamic)['profile_pic'],
        painTarget: (event.snapshot.value as dynamic)['pain_target'],
        deviceID: (event.snapshot.value as dynamic)['device_id']);
  }

  Stream<FirebaseUserData> get userData {
    return _users.child(uid).onChildChanged.map(_userDataFromSnapshot);
  }

  DatabaseReference get getUser {
    return _users.child(uid);
  }
}
