import 'dart:async';

import 'package:flutter/material.dart';
import 'database/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import './Drawer.dart';

class PersonalProfile extends StatefulWidget {
  @override
  _ProfleState createState() => _ProfleState();
}

class _ProfleState extends State<PersonalProfile> {
  SharedPreference helper = SharedPreference();
  Profile myProfile = Profile();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.limeAccent,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                    child: profileImage(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton.icon(
                        onPressed: () => getImage(true),
                        icon: Icon(Icons.camera),
                        label: Text("Capture"),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      RaisedButton.icon(
                        onPressed: () => getImage(false),
                        icon: Icon(Icons.image),
                        label: Text("Gallery"),
                      ),
                    ],
                  ),
                  Builder(
                    builder: (BuildContext context) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.assignment_ind),
                            hintText: myProfile.name),
                        onSubmitted: (value) {
                          Icon icons = Icon(Icons.done);
                          String response;
                          if (value.isEmpty) {
                            response = "Name can't be empty";
                            icons = Icon(Icons.error_outline);
                          } else {
                            setState(() {
                              myProfile.name = value;
                              helper.setProfile(myProfile);
                              value = '';
                              response = 'Name Updated';
                            });
                          }
                          final SnackBar snack = SnackBar(
                            backgroundColor: Colors.purple,
                            content: Row(
                              children: <Widget>[
                                icons,
                                SizedBox(width: 10.0),
                                Text(
                                  response,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                          Scaffold.of(context).showSnackBar(snack);
                        },
                      ),
                    ),
                  ),
                  Builder(
                    builder: (BuildContext context) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            hintText: myProfile.emailId),
                        onSubmitted: (value) {
                          String response;
                          Icon icons = Icon(Icons.done);
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);
                          if (!emailValid) {
                            response = 'Invalid Email Address';
                            icons = Icon(Icons.error_outline);
                          } else {
                            setState(() {
                              myProfile.emailId = value;
                              helper.setProfile(myProfile);
                              value = '';
                              response = 'Email Id Updated';
                            });
                          }
                          final SnackBar snack = SnackBar(
                            backgroundColor: Colors.purple,
                            content: Row(
                              children: <Widget>[
                                icons,
                                SizedBox(width: 10.0),
                                Text(
                                  response,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                          Scaffold.of(context).showSnackBar(snack);
                        },
                      ),
                    ),
                  ),
                ],
              ),
        drawer: SideNav(),
      ),
    );
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
        radius: 100.0,
        backgroundImage: FileImage(File(myProfile.imagePath)),
      );
    }
    return CircleAvatar(
      radius: 75.0,
      child: FlutterLogo(
        size: 100.0,
      ),
      backgroundColor: Colors.white,
    );
  }
}
