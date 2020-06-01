import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'database/shared_preferences.dart';

class SideNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //debugPrint(ModalRoute.of(context).settings.name);
    return Drawer(
      elevation: 2.0,
      child: ListView(
        children: <Widget>[
          DrawerHeader(),
          InkWell(
            onTap: () {
              if (ModalRoute.of(context).settings.name == "/home") return;
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', ModalRoute.withName("/home"));
            },
            child: ListTile(
              leading: Icon(Icons.mail),
              title: Text("Primary"),
            ),
          ),
          InkWell(
            onTap: () {
              if (ModalRoute.of(context).settings.name == "/archive") return;
              Navigator.pushNamedAndRemoveUntil(
                  context, '/archive', ModalRoute.withName("/home"));
            },
            child: ListTile(
              leading: Icon(Icons.archive),
              title: Text("Archive"),
            ),
          ),
          InkWell(
            onTap: () {
              if (ModalRoute.of(context).settings.name == "/favourites") return;
              Navigator.pushNamedAndRemoveUntil(
                  context, '/favourites', ModalRoute.withName("/home"));
            },
            child: ListTile(
              leading: Icon(Icons.bookmark),
              title: Text("Favourites"),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerHeader extends StatefulWidget {
  @override
  _DrawerHeader createState() => _DrawerHeader();
}

class _DrawerHeader extends State<DrawerHeader> {
  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() async {
    setState(() {
      _isLoading = true;
    });
    Profile _myProfile = await helper.getProfile();
    setState(() {
      myProfile = _myProfile;
      _isLoading = false;
    });
  }

  SharedPreference helper = SharedPreference();
  Profile myProfile = Profile();
  bool _isLoading = false;

  Future getImage(bool isCamera) async {
    File _image;
    isCamera
        ? _image = await ImagePicker.pickImage(source: ImageSource.camera)
        : _image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (_image != null) {
      setState(() {
        myProfile.imagePath = _image.path;
        helper.setProfile(myProfile);
      });
    }
  }

  Widget profileImage() {
    if (myProfile.imagePath != null && File(myProfile.imagePath).existsSync()) {
      return CircleAvatar(
        radius: 25.0,
        backgroundImage: FileImage(File(myProfile.imagePath)),
      );
    }
    return CircleAvatar(
      radius: 25.0,
      child: FlutterLogo(
        size: 50.0,
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : UserAccountsDrawerHeader(
            accountName: new Text(myProfile.name),
            accountEmail: Text(myProfile.emailId),
            currentAccountPicture: profileImage(),
            otherAccountsPictures: <Widget>[
              IconButton(
                icon: Icon(Icons.camera),
                onPressed: () {
                  getImage(true);
                },
              ),
              IconButton(
                icon: Icon(Icons.image),
                onPressed: () {
                  getImage(false);
                },
              ),
            ],
          );
  }
}
