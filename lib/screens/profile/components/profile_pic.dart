import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lbpalert/services/auth.dart';
import 'package:lbpalert/services/database.dart';
import 'package:lbpalert/services/storage.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? pickedImage;
  bool showProfilePic = false;
  String? imageURL;
  final _auth = AuthService();
  final _storage = StorageService();

  @override
  void initState() {
    super.initState();
    checkProfilePic();
  }

  void checkProfilePic() async {
    final uid = _auth.getUserID;
    final UserDatabaseService _users = UserDatabaseService(uid: uid);

    DatabaseReference child = _users.getUser;
    final userData = await child.get();
    if (userData.exists) {
      setState(() {
        imageURL = (userData.value as dynamic)["profile_pic"];
      });
      showProfilePic = true;
    } else {
      showProfilePic = false;
    }
  }

  void pickImageFromGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return null;
    }
    pickedImage = File(image.path);

    _storage.storeProfilePic(_auth.getUserID, pickedImage).then((newImage) {
      setState(() {
        imageURL = newImage;
      });

      showProfilePic = true;
    });
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
          CircleAvatar(
            backgroundImage: showProfilePic
                ? NetworkImage(imageURL!) as ImageProvider
                : AssetImage("assets/images/defaultAvi.png"),
          ),
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
