import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          ListTile(
            leading: Icon(Icons.archive),
            title: Text("Archive"),
          ),
          InkWell(
            onTap: () {
              if (ModalRoute.of(context).settings.name == "/favourites") return;
              Navigator.pushNamedAndRemoveUntil(
                  context, '/favourites', ModalRoute.withName("/home"));
            },
            child: ListTile(
              leading: Icon(Icons.bookmark),
              title: Text("Bookmarked"),
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
    loadImage();
  }

  File image;
  String _imagePath;
  Future getImage(bool isCamera) async {
    File _image;
    isCamera
        // ignore: deprecated_member_use
        ? _image = await ImagePicker.pickImage(source: ImageSource.camera)
        // ignore: deprecated_member_use
        : _image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (_image != null) {
      setState(() {
        image = _image;
        saveImage(image.path);
      });
    }
  }

  saveImage(path) async {
    SharedPreferences saveImage = await SharedPreferences.getInstance();
    saveImage.setString('imagepath', path);
  }

  void loadImage() async {
    SharedPreferences saveImage = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = saveImage.get('imagepath');
    });
  }

  CircleAvatar profileImage() {
    if (image != null) {
      return CircleAvatar(
        backgroundImage: FileImage(image),
      );
    } else if (_imagePath != null && File(_imagePath).existsSync()) {
      return CircleAvatar(
        backgroundImage: FileImage(File(_imagePath)),
      );
    }
    return CircleAvatar(
      child: FlutterLogo(
        size: 50.0,
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: new Text("Lakshya Singh"),
      accountEmail: Text("lakshay.singh1108@gmail.com"),
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
