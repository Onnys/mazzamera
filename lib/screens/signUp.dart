import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mazzamera/components/button.dart';
import 'package:mazzamera/screens/mazzamera_home.dart';

class Login extends StatefulWidget {
  static const String id = 'Login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final _globalKey = GlobalKey<ScaffoldState>();
  bool ignore = false;
  double opacity = 1;
  Icon icon = Icon(Icons.remove_red_eye);
  bool seePassword = true;
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _name, _imageUrl;
  bool hidebutton = true;

  void _hideButton() {
    setState(() {
      hidebutton = false;
    });
  }

  Future<User> _signWithGoogle() async {
    User user;
    setState(() {
      opacity = 0.7;
      ignore = true;
    });
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      user = (await _auth.signInWithCredential(credential)).user;
      if (user != null) {
        _name = user.displayName;
        _email = user.email;
        _imageUrl = user.photoURL;
      }
    } on FirebaseAuthException catch (e) {
      _globalKey.currentState.showSnackBar(
        SnackBar(
          content: Container(
              child: Text(
            'Failed with ${e.code}',
            textAlign: TextAlign.center,
          )),
        ),
      );
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: IgnorePointer(
        ignoring: ignore,
        child: Form(
          key: _formKey,
          child: Scaffold(
            key: _globalKey,
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white10,
              centerTitle: true,
              title: Text(
                'Create account',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                (hidebutton)
                    ? Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Button(
                            hasIcon: true,
                            color: Colors.blueGrey,
                            label: 'Sign up with Google',
                            labelColor: Colors.white,
                            onPressed: () async {
                              setState(() {
                                opacity = 1;
                                ignore = true;
                              });
                              await _signWithGoogle().whenComplete(
                                () => Navigator.pushNamedAndRemoveUntil(
                                    context, Home.id, (route) => false),
                              );
                              setState(() {
                                opacity = 1;
                                ignore = false;
                              });
                            },
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 1,
                      ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      style: TextStyle(
                          color: Colors.black87,
                          decoration: TextDecoration.none),
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      cursorColor: Colors.black12,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        _email = value;
                      },
                      onTap: () => _hideButton(),
                      decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 18),
                          labelText: 'Email',
                          suffixIcon: Icon(Icons.email)),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.length < 5) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _password = value;
                      },
                      onTap: () => _hideButton(),
                      obscureText: seePassword,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        labelText: 'Password (min. 8 characters)',
                        labelStyle: TextStyle(fontSize: 18),
                        suffixIcon: IconButton(
                            icon: icon,
                            onPressed: () {
                              setState(() {
                                if (seePassword) {
                                  icon = Icon(Icons.visibility_off);
                                  seePassword = false;
                                } else {
                                  icon = Icon(Icons.remove_red_eye);
                                  seePassword = true;
                                }
                              });
                            }),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Button(
                    hasIcon: false,
                    color: Colors.white54,
                    label: 'Sign up with email',
                    labelColor: Colors.black,
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        opacity = 0.7;
                        ignore = true;
                      });
                      if (_formKey.currentState.validate()) {
                        try {
                          final _signUp =
                              await _auth.createUserWithEmailAndPassword(
                                  email: _email, password: _password);
                          if (_signUp != null) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, Home.id, (route) => false);
                            setState(() {
                              opacity = 1;
                              ignore = false;
                            });
                          }
                          setState(() {
                            opacity = 1;
                            ignore = false;
                          });
                        } on FirebaseAuthException catch (e) {
                          _globalKey.currentState.showSnackBar(
                            SnackBar(
                              content: Container(
                                  child: Text(
                                'Failed with ${e.code}',
                                textAlign: TextAlign.center,
                              )),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
                Text(
                  'We may use your email for notifications from mazzamera app as well as uploaded content. \n We will share all files you uploaded with Mazzamera users.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black26),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
