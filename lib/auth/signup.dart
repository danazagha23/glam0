import 'package:flutter/material.dart';
import 'package:glam0/models/user.dart';
import 'package:glam0/blocks/auth_block.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final User user = User(id: '',password: '', name: '', email: '', address: '', phone: '');
  late String confirmPassword;
  @override
  Widget build(BuildContext context) {
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
                        if (value!.isEmpty) {
                          return 'Please Enter your name';
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
                        if (value!.isEmpty) {
                          return 'Please Enter Email Address';
                        }
                        return null;
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
                          if (value!.isEmpty) {
                            return 'Please Enter Password';
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
                        if (value!.isEmpty) {
                          return 'Please Enter your Phone number';
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
                            // if (_formKey.currentState!.validate() && !auth.loading) {
                              _formKey.currentState!.save();
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              auth.register(user);
                              Navigator.pushNamed(context, '/settings');
                            // }
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
