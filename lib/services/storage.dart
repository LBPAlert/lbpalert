import 'package:firebase_storage/firebase_storage.dart';
import 'package:lbpalert/services/database.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> storeProfilePic(userId, imageFile) async {
    try {
      var fileName = userId + '.jpg';

      UploadTask uploadTask = _storage
          .ref()
          .child('profile_images')
          .child(fileName)
          .putFile(imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      String profileImageUrl = await snapshot.ref.getDownloadURL();
      await DatabaseService(uid: userId).updateProfilePic(profileImageUrl);
      return profileImageUrl;
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to store image');
    }
  }
}
