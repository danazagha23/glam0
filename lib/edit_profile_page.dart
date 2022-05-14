import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class profile extends StatefulWidget {
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  var n = TextEditingController();
  var e = TextEditingController();
  var p = TextEditingController();
  var ph = TextEditingController();
  var add = TextEditingController();
  late bool isSignin;
  var name ;
  var email;
  var password;
  var phone;
  var address;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("cust_name")??'';
      email = preferences.getString("email")??'';
      password = preferences.getString("password")??'';
      phone = preferences.getString("phone")??'';
      address = preferences.getString("address")??'';
    });
    isSignin= true;
    n.text = name??'';
    e.text = email??'';
    p.text = password??'';
    ph.text = phone??'';
    add.text = address??'';
  }

  var cust_id ;

  Future getID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      cust_id = preferences.getString("cust_id")??'';
    });
  }

  @override
  void initState() {
    getID();
    getPref();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(backgroundColor: Color(0xffDB3022),
            title: Text('Edit Profile'),
          ),
          body: ListView(
            padding: EdgeInsets.fromLTRB(40, 30, 40, 5),
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50, bottom: 10),
                child: ButtonTheme(
                  buttonColor:  Color(0xffDB3022),
                  minWidth: double.infinity,
                  height: 40.0,
                  child: RaisedButton(
                    onPressed: () async {
                      final response = await http.post(Uri.parse(CONFIG.PROFILE),
                          body: {
                            'id': cust_id,
                            'name': n.text.toString(),
                            'email': e.text.toString(),
                            'password': p.text.toString(),
                            'phone': ph.text.toString(),
                            'address': add.text.toString()
                          }
                      );
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              const Text(
               'Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextField(
                  controller: n,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (name) {},
              ),
              const Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: e,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (name) {},
              ),
              const Text(
                'Password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: p,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (name) {},
              ),
              const Text(
                'Phone',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: add,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (name) {},
              ),
               Text(
                'Address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: ph,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (name) {},
              ),

            ],
          ),
        ),
      ),
    );
  }
}
