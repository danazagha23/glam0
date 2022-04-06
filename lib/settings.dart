import 'package:flutter/material.dart';
import 'package:glam0/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSignin= false;
  var name;
  var email;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
       name = preferences.getString("name");
       email = preferences.getString("email");
      isSignin= true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = User(password: '', name: '', email: '', address: '', phone: '');
    getPref();
    return Scaffold(
        appBar: AppBar(
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
                    child: Container(
                      margin: EdgeInsets.only(right: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: new BorderRadius.circular(60),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white, size: 32,
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
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
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ):
                          Text(""),
                      )
                      )],
                  ),
                  Expanded(
                    child:  ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.edit, color: Theme.of(context).accentColor, size: 28,),
                            title: Text('Profile', style: TextStyle(color: Colors.black, fontSize: 17)),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.notifications, color: Theme.of(context).accentColor, size: 28,),
                            title: Text('Notifications', style: TextStyle(color: Colors.black, fontSize: 17)),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.panorama, color: Theme.of(context).accentColor, size: 28,),
                            title: Text('Progress', style: TextStyle(color: Colors.black, fontSize: 17)),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.favorite, color: Theme.of(context).accentColor, size: 28,),
                            title: Text('Favorite', style: TextStyle(color: Colors.black, fontSize: 17)),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.feedback, color: Theme.of(context).accentColor, size: 28,),
                            title: Text('Feedback', style: TextStyle(color: Colors.black, fontSize: 17)),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor),
                          ),
                        ),
                        Card(
                          child:  ListTile(
                            leading: Icon(Icons.add_photo_alternate, color: Theme.of(context).accentColor, size: 28,),
                            title: Text('About Us', style: TextStyle(color: Colors.black, fontSize: 17)),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.vpn_key, color: Theme.of(context).accentColor, size: 28,),
                            title: Text('Change Password', style: TextStyle(color: Colors.black, fontSize: 17)),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.lock, color: Theme.of(context).accentColor, size: 28,),
                            title: Text('Logout', style: TextStyle(color: Colors.black, fontSize: 17)),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor),
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