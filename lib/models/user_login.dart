import 'package:shared_preferences/shared_preferences.dart';

class UserLogin {
  bool? status = false;
  String? message;
  String? username;
  String? password;
  UserLogin({
    this.status,
    this.message,
    this.username,
    this.password,
  });
  Future prefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("status", status!);
    prefs.setString("message", message!);
    prefs.setString("Username", username!);
    prefs.setString("Password", password!);
  }

  Future getUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserLogin userLogin = UserLogin(
        status: prefs.getBool("status")!,
        message: prefs.getString("message")!,
        username: prefs.getString("email")!,
        password: prefs.getString("role")!);
    return userLogin;
  }
}
