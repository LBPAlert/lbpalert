import 'package:lbpalert/models/user.dart';
import 'package:lbpalert/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on Firebase User
  FirebaseUser _userFromFirebaseUser(User? user) {
    return FirebaseUser(uid: user!.uid);
  }

  // auth changes user stream
  Stream<FirebaseUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  String get getUserID {
    return _auth.currentUser!.uid;
  }

  String? get getUserEmail {
    return _auth.currentUser!.email;
  }

  // Sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
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
      return _userFromFirebaseUser(user);
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
  Future registerEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Create document for User Firestore Database
      await DatabaseService(uid: user!.uid).createUserData("", "", "", "", "");
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

  // Change Password
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

  // Change Password
  Future passwordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return "Password Reset Email Sent";
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
