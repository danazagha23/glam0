import 'package:flutter/material.dart';
import 'package:glam0/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocks/auth_block.dart';
import 'edit_profile_page.dart';



class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late profile p;
  late AuthBlock auth;
  late bool isSignin;
  var name ;
  var email;
  var password ;
  var phone;
  var address ;

  savePref(String name,String email,String password,String phone,String address,bool isSignin) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("cust_name",name);
    preferences.setString("email",email);
    preferences.setString("password",password);
    preferences.setString("phone",phone);
    preferences.setString("address",address);
    preferences.setBool("isSignin",isSignin);
  }
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
       name = preferences.getString("cust_name")??'';
       email = preferences.getString("email")??'';
       password = preferences.getString("password")??'';
       phone = preferences.getString("phone")??'';
       address = preferences.getString("address")??'';
       isSignin = preferences.getBool("isSignin")!;

    });
  }

  @override
  void initState() {
    super.initState();
    isSignin= false;
    getPref();
  }
  @override
  Widget build(BuildContext context) {
    final User user = User(id: '',password: '', name: '', email: '', address: '', phone: '');
    // getPref();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffDB3022),
          title: Text('Settings'),
        ),
        body: SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment(1, 1),
                    width: MediaQuery.of(context).size.width,
                    height: 190,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage("https://images.pexels.com/photos/236047/pexels-photo-236047.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                      ),
                    ),
                    // child: Container(
                    //   margin: EdgeInsets.only(right: 10, bottom: 10),
                    //   decoration: BoxDecoration(
                    //     color: Theme.of(context).primaryColor,
                    //     borderRadius: new BorderRadius.circular(60),
                    //   ),
                    //   padding: const EdgeInsets.all(10.0),
                    //   child: Icon(
                    //     Icons.camera_alt,
                    //     color: Colors.white, size: 32,
                    //   ),
                    // ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide( //                   <--- left side
                              color: Colors.grey.shade300,
                              width: 1.0,
                            )
                          ),
                        ),
                        child:  Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                          child:
                          isSignin ? Text(
                            name,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ):
                          Text(""),
                      )
                      )],
                  ),
                  Expanded(
                    child:  ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                    isSignin? Card(
                          child: ListTile(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => profile(),),);
                              },
                            leading: Icon(Icons.edit, color: Colors.black, size: 28,),
                            title: Text('Your information', style: TextStyle(color: Colors.black, fontSize: 17)),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor),
                          ),
                        ):Card(),
                    isSignin?Card(
                          child: ListTile(
                            leading: Icon(Icons.notifications, color: Colors.black, size: 28,),
                            title: Text('Notifications', style: TextStyle(color: Colors.black, fontSize: 17)),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor),
                          ),
                        ):Card(),
                    isSignin?Card(
                          child: ListTile(
                            onTap:(){
                              Navigator.pushNamed(context, '/cart');
                            } ,
                            leading: Icon(Icons.panorama, color: Colors.black, size: 28,),
                            title: Text('My cart', style: TextStyle(color: Colors.black, fontSize: 17)),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor),
                          ),
                        ):Card(),
                    isSignin?Card(
                          child: ListTile(
                            onTap:(){
                                Navigator.pushNamed(context, '/wishlist');
                            } ,
                            leading: Icon(Icons.favorite, color: Colors.black, size: 28,),
                            title: Text('Favorite', style: TextStyle(color: Colors.black, fontSize: 17)),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor),
                          ),
                        ):Card(),
                        Card(
                          child:
                          isSignin ? ListTile(
                            leading: Icon(Icons.lock, color: Colors.black, size: 28,),
                            title: Text('Logout', style: TextStyle(color: Colors.black, fontSize: 17)),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor),
                            onTap: () async{

                              SharedPreferences preferences = await SharedPreferences.getInstance();
                              setState(() {
                                savePref(name, email, password, phone, address,false);
                                // isSignin=false;
                              });
                              preferences.remove("name");
                              preferences.remove("email");
                              preferences.remove("password");
                              preferences.remove("phone");
                              preferences.remove("address");

                              Navigator.pushNamed(context, '/settings');
                            },
                          ):ListTile(
                            leading: Icon(Icons.lock, color: Theme.of(context).accentColor, size: 28,),
                            title: Text('Login', style: TextStyle(color: Colors.black, fontSize: 17)),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor),
                            onTap: (){
                              Navigator.pushNamed(context, '/auth');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
        )
    );
  }
}
