class FirebaseUser {
  final String uid;

  FirebaseUser(this.uid);
}

class FirebaseUserData {
  final String uid;
  final String firstname;
  final String lastname;
  final String email;
  final String profilePic;
  final int painTarget;
  final String deviceID;

  FirebaseUserData(this.uid, this.firstname, this.lastname, this.email,
      this.profilePic, this.painTarget, this.deviceID);
}
