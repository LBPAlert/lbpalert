import 'dart:async';
import 'package:lbpalert/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lbpalert/services/api.dart';

class UserDatabaseService {
  final String uid;
  UserDatabaseService({required this.uid});

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

  DatabaseReference get getUser {
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

class PredictionDatabaseService {
  final String uid;
  PredictionDatabaseService({required this.uid});

  final List<List<double>> sensorReadings = [];
  late StreamSubscription sensorDataStreamSubscription;

  final DatabaseReference _sensorRef =
      FirebaseDatabase.instance.ref("Sensor_Data");

  Future getMLPredictions() async {
    Stream<DatabaseEvent> sensorDataStream = _sensorRef.onValue;
    sensorDataStreamSubscription =
        sensorDataStream.listen((DatabaseEvent event) async {
      final sensor00 =
          (event.snapshot.value as dynamic)["sEMG00"]["voltage_Level"];
      final sensor01 =
          (event.snapshot.value as dynamic)["sEMG01"]["voltage_Level"];
      final sensor10 =
          (event.snapshot.value as dynamic)["sEMG10"]["voltage_Level"];
      final sensor11 =
          (event.snapshot.value as dynamic)["sEMG11"]["voltage_Level"];

      sensorReadings.add([sensor00, sensor01, sensor10, sensor11]);

      print(sensorReadings.length);

      if (sensorReadings.length == 500) {
        sensorDataStreamSubscription.pause();
        final json = sensorReadings.toString();
        await makePostRequest(json).then(
          (prediction) {
            // setState(() {
            //   apiData = prediction;
            // });
            // getPredictiveColor(prediction);
            DatabaseReference predictionListRef =
                FirebaseDatabase.instance.ref("users/$uid/predictions");
            DatabaseReference newPredictionRef = predictionListRef.push();
            final now = DateTime.now().toString().split(".");
            final timestamp = now[0];

            newPredictionRef.set({
              timestamp: prediction,
            });
            sensorReadings.removeAt(0);
          },
        );
        sensorDataStreamSubscription.resume();
      }
    });
  }
}
