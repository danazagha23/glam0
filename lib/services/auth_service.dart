import 'dart:convert';
import 'package:glam0/config.dart';
import 'package:glam0/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  savePref(String name,String email) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("name",name);
    preferences.setString("email",email);
    // print(preferences.getString("name"));
    // print(preferences.getString("email"));
  }
  // Create storage
  Future login(UserCredential userCredential) async {
    final response = await http.post(Uri.parse(CONFIG.LOGIN),
        body: {
      'email': userCredential.email,
      'password': userCredential.password
    });

    if (response.body=="failed" || response.body=="not exist") {
      Fluttertoast.showToast(
          msg: "Invalid Credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return response.body;
    } else {
       List userdata = response.body.split(",");
      Fluttertoast.showToast(
          msg:"success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      setUser(response.body);
      savePref(userdata[0],userdata[1]);
      return response.body;
    }
  }

  Future register(User user) async {
    final response = await http.post(Uri.parse(CONFIG.REGISTER),
        body: {
          'name': user.name,
          'password': user.password,
          'email': user.email,
          'address': user.address,
          'phone': user.phone
        });
    if (response.body == "success") {
      // If the call to the server was successful, parse the JSON.
      // return User.fromJson(json.decode(response.body));
      return response.body;
    } else {
        Fluttertoast.showToast(
            msg: 'Email already exist',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);

      // If that call was not successful, throw an error.
//      throw Exception(response.body);
      return response.body;
    }
  }

  setUser(String value) async {
    await storage.write(key: 'user', value: value);
  }

  getUser() async {
    String? user = await storage.read(key: 'user');
    if (user != null) {
      return user;
    }
  }
  logout() async {
    await storage.delete(key: 'user');
  }
}
