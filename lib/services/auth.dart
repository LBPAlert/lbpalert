import 'dart:async';
import 'package:lbpalert/constants.dart';
import 'package:lbpalert/models/user.dart';
import 'package:lbpalert/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on Firebase User
  FirebaseUser _userFromFirebaseUser(User? user) {
    if (user == null) {
      return FirebaseUser("");
    } else {
      return FirebaseUser(user.uid);
    }
  }

  // auth changes user stream
  Stream<FirebaseUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  String get getUserID {
    return _auth.currentUser!.uid;
  }

  User? get getCurrentUser {
    return _auth.currentUser;
  }

  String? get getUserEmail {
    return _auth.currentUser!.email;
  }

  Future updateDisplayName(String firstname, String lastname) async {
    try {
      final displayName = firstname + " " + lastname;
      await _auth.currentUser!.updateDisplayName(displayName);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateEmail(String email) async {
    try {
      await _auth.currentUser!.updateEmail(email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in Email and Password
  Future signInEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user!.emailVerified) {
        return _userFromFirebaseUser(user);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign Out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register
  Future registerEmailandPassword(
      String email, String password, String firstname, String lastname) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Create document for User Firestore Database
      await UserDatabaseService(user!.uid).createUserData(
          firstname,
          lastname,
          email,
          "https://firebasestorage.googleapis.com/v0/b/lbpalert.appspot.com/o/profile_images%2FdefaultAvi.png?alt=media&token=fe42b668-769c-4464-a472-481b4576320f",
          defaultPainRating,
          "");
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Change Password in app
  Future changePassword(
      String email, String old_password, String new_password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: old_password);
      User? user = result.user;

      if (user != null) {
        await user.updatePassword(new_password);
        return "Updated User Password";
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Forgot Password Reset
  Future passwordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Password Reset Email Sent";
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
