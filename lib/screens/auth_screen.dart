import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/httpException.dart';
import 'package:shopping_app/providers/auth.dart';

enum AuthMode { signUP, login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/AuthScreen';
  @override
  Widget build(BuildContext context) {
    // final deviceScreen;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent.withOpacity(0.7), Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // stops: [0, 1]
            ),
          )),
          SingleChildScrollView(
              child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 94),
                        transform: Matrix4.rotationZ(-8 * pi / 180)
                          ..translate(-10.0),
                        decoration: BoxDecoration(
                            color: Colors.deepOrange.shade900,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 8,
                                  color: Colors.black26,
                                  offset: Offset(0, 2))
                            ]),
                        child: Text(
                          'SHOP',
                          style: TextStyle(fontSize: 40, color: Colors.yellow),
                        ))),
                Flexible(
                    flex: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                    child: AuthCard())
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  AuthMode authMode = AuthMode.login;
  final _form = GlobalKey<FormState>();
  bool isLoading = false;
  var authData = {'email': '', 'password': ''};

  AnimationController _controller;
  Animation<Size> _heightAnimation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _heightAnimation = Tween<Size>(
            begin: Size(double.infinity, 260), end: Size(double.infinity, 360))
        .animate(CurvedAnimation(
            parent: _controller, curve: Curves.linearToEaseOut));
    _heightAnimation.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose(); // TODO: implement dispose
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  void switchAuthMode() {
    if (authMode == AuthMode.signUP) {
      setState(() {
        authMode = AuthMode.login;
      });
      _controller.forward();
    } else {
      setState(() {
        authMode = AuthMode.signUP;
      });
      _controller.reverse();
    }
  }

  Future<void> submitForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    //  'AIzaSyA000TI3yTpvqFWKqg6jI24DFr7819EHpI'
    setState(() {
      isLoading = true;
    });
    try {
      if (authMode == AuthMode.signUP) {
        print('sign up');
        await Provider.of<Auth>(context, listen: false)
            .signUp(authData['email'], authData['password']);
      } else {
        print('sign In');
        await Provider.of<Auth>(context, listen: false)
            .signIn(authData['email'], authData['password']);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication Failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find user with that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could\'nt authenticate you.Please try again later';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceScreen = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: authMode == AuthMode.signUP ? 320 : 260,
          width: deviceScreen.width * 0.75,
          constraints: BoxConstraints(
            minHeight: authMode == AuthMode.signUP ? 320 : 260,
          ),
          child: Form(
              key: _form,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        onChanged: (value) {
                          authData['email'] = value;
                        },
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      // const SizedBox(height: 5),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        onChanged: (value) {
                          authData['password'] = value;
                          print('auth' + authData['password']);
                        },
                        validator: (value) {
                          if (value.isEmpty || (value.length < 8)) {
                            return 'your Password is too short';
                          }
                          return null;
                        },
                      ),
                      if (authMode == AuthMode.signUP)
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Confirm Password'),
                          validator: (value) {
                            if (authData['password'] != value) {
                              print(authData['password']);
                              print(value);

                              return 'Password did\'nt match';
                            }
                            return null;
                          },
                        ),
                      // const SizedBox(height: 10),
                      if (isLoading)
                        Container(
                            padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator()),
                      RaisedButton(
                        onPressed: submitForm,
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: switchAuthMode,
                          child: Text(
                            '${authMode == AuthMode.signUP ? 'Login' : 'SignUp'}  Instead',
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ))
                    ],
                  ),
                ),
              )),
        ));
  }
}
