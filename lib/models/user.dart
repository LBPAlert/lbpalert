class FirebaseUser {
  final String uid;

  FirebaseUser({required this.uid});
}

class FirebaseUserData {
  final String uid;
  final String firstname;
  final String lastname;
  final String phoneNumber;
  final String address;

  FirebaseUserData(
      {required this.uid,
      required this.phoneNumber,
      required this.address,
      required this.firstname,
      required this.lastname});
}
