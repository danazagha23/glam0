import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:glam0/models/user.dart';
import 'package:glam0/blocks/auth_block.dart';
import 'package:provider/provider.dart';
import 'package:glam0/validator.dart';
import '../home/home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final User user = User(id: '',password: '', name: '', email: '', address: '', phone: '',token: '');
  var fbm = FirebaseMessaging.instance;

  late String confirmPassword;
  @override
  Widget build(BuildContext context) {
    fbm.getToken().then((token) {
      print('===================Token============================');
      print(token.toString());
      user.token = token.toString()!;
    });
    return Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      validator: (value) {
                        String pattern = r'(^[a-zA-Z ]*$)';
                        RegExp regExp = new RegExp(pattern);
                        if (value!.length == 0) {
                          return "Name is Required";
                        } else if (!regExp.hasMatch(value!)) {
                          return "Name must be a-z and A-Z";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          user.name = value!;

                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        labelText: 'Name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      validator: (value) {
                        String pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regExp = new RegExp(pattern);
                        if (value!.length == 0) {
                          return "Email is Required";
                        } else if (!regExp.hasMatch(value!)) {
                          return "Invalid Email";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          user.email = value!;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Email',
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                        validator: (value) {
                          if(value!.length==0){
                            return "Password can't be empty";
                          } else if (value!.length < 8){
                            return "Password must be longer than 8 characters";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            user.password = value!;
                          });
                        },
                        onChanged: (text) {
                          user.password = text;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                          labelText: 'Password',
                        ),
                        obscureText: true),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Confirm Password';
                      } else if (user.password != confirmPassword) {
                        return 'Password fields dont match';
                      }
                      return null;
                    },
                    onChanged: (text) {
                      confirmPassword = text;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Same Password',
                      labelText: 'Confirm Password',
                    ),
                    obscureText: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter your Address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          user.address = value!;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Address',
                        labelText: 'Address',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      validator: (value) {
                        String pattern = r'(^[0-9]*$)';
                        RegExp regExp = new RegExp(pattern);
                        if (value!.length == 0) {
                          return "Mobile is Required";
                        } else if (value!.length != 10) {
                          return "Mobile number must 10 digits";
                        } else if (!regExp.hasMatch(value!)) {
                          return "Mobile Number must be digits";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          user.phone = value!;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Phone number',
                        labelText: 'Phone number',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: SizedBox(
                      width: 150,
                      height: 50,
                      child: Consumer<AuthBlock>(
                          builder:
                          (BuildContext context, AuthBlock auth, Widget? child) {
                        return RaisedButton(
                          color: Color(0xffDB3022),
                          textColor: Colors.white,
                          child: auth.loading && auth.loadingType == 'register' ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ) : Text('Sign Up'),
                          onPressed: () {
                            if (_formKey.currentState!.validate() && !auth.loading) {
                              _formKey.currentState!.save();
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.

                              auth.register(user);
                              Navigator.pushNamed(context, '/settings');
                            }
                          },
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}
