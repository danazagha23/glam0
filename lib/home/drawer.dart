import 'package:flutter/material.dart';
import 'package:glam0/blocks/auth_block.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glam0/settings.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool isSignin=false;
  var name;
  var email;
  savePref(String name,String email,String password,String phone,String address,bool isSignin) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("name",name);
    preferences.setString("email",email);
    preferences.setString("password",password);
    preferences.setString("phone",phone);
    preferences.setString("address",address);
    preferences.setBool("isSignin",isSignin);
  }
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name");
      email = preferences.getString("email");
      isSignin = preferences.getBool("isSignin")!;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    return Column(
      children: <Widget>[
        if (auth.isLoggedIn)
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/drawer-header.jpg'),
            )),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://avatars2.githubusercontent.com/u/2400215?s=120&v=4'),
            ),
            accountEmail: Text(auth.user['user_email']),
            accountName: Text(auth.user['user_display_name']),
          ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.home, color:  Color(0xffDB3022)),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_basket,
    color:  Color(0xffDB3022)),
                title: Text('Shop'),
                trailing: Text('New',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/shop');
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.category, color:  Color(0xffDB3022)),
                title: Text('Categorise'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/categorise');
                },
              ),
              isSignin ? ListTile(
                leading:
                    Icon(Icons.favorite, color:  Color(0xffDB3022)),
                title: Text('My Wishlist'),
                trailing: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text('4',
                      style: TextStyle(color: Colors.white, fontSize: 10.0)),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/wishlist');
                },
              ):ListTile(),
              isSignin ? ListTile(
                leading: Icon(Icons.shopping_cart,
                    color:  Color(0xffDB3022)),
                title: Text('My Cart'),
                trailing: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text('2',
                      style: TextStyle(color: Colors.white, fontSize: 10.0)),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/cart');
                },
              ):
              ListTile(),
              Divider(),
              isSignin ?ListTile(
                leading:
                    Icon(Icons.settings, color:  Colors.black),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ):ListTile(),
              isSignin ?
              ListTile(
                leading: Icon(Icons.exit_to_app,
                    color:  Colors.black),
                title: Text('Logout'),
                onTap: () async {
                  isSignin=false;
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  preferences.remove("name");
                  preferences.remove("email");
                  setState(() {
                    savePref("name", "", "", "", "",false);
                  });
                  Navigator.pushNamed(context, '/home/home');
                },
              ):
              ListTile(
                leading: Icon(Icons.lock, color:  Colors.black),
                title: Text('Login'),
                onTap: () {
                  isSignin=true;
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/auth');
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
