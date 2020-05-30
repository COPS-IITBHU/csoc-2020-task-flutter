import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static SharedPreference _sharedPreference;
  static SharedPreferences _preferences;

  SharedPreference._createInstance();

  factory SharedPreference() {
    if (_sharedPreference == null) {
      _sharedPreference = SharedPreference._createInstance();
    }
    return _sharedPreference;
  }

  Future<SharedPreferences> get preferences async {
    if (_preferences == null)
      _preferences = await SharedPreferences.getInstance();

    return _preferences;
  }

  Future<Profile> getProfile() async {
    SharedPreferences _local = await this.preferences;
    Profile myProfile = Profile();

    myProfile.name = _local.getString('name') ?? myProfile.name;
    myProfile.imagePath = _local.getString('imagePath') ?? myProfile.imagePath;
    myProfile.emailId = _local.getString('emailId') ?? myProfile.emailId;

    return myProfile;
  }

  void setProfile(Profile myProfile) async {
    SharedPreferences _local = await this.preferences;
    _local.setString('imagePath', myProfile.imagePath);
    _local.setString('name', myProfile.name);
    _local.setString('emailId', myProfile.emailId);
    print(myProfile.imagePath);
  }
}

class Profile {
  Profile(
      {this.name = 'Lakshya Singh',
      this.emailId = 'lakshya.singh1108@gmail.com',
      this.imagePath});

  String name;
  String emailId;
  String imagePath;
}
