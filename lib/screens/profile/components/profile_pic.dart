import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lbpalert/services/auth.dart';
import 'package:lbpalert/services/storage.dart';

class ProfilePic extends StatelessWidget {
  final String profilePic;
  ProfilePic(this.profilePic);

  void pickImageFromGallery() async {
    File? pickedImage;
    final _auth = AuthService();
    final _storage = StorageService();
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return null;
    }
    pickedImage = File(image.path);
    _storage.storeProfilePic(_auth.getUserID, pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(backgroundImage: NetworkImage(profilePic)),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                  primary: Colors.white,
                  backgroundColor: Color(0xFFF5F6F9),
                ),
                onPressed: () {
                  pickImageFromGallery();
                },
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
