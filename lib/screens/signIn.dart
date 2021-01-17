import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mazzamera/components/button.dart';
import 'package:mazzamera/screens/mazzamera_home.dart';

class SignIn extends StatefulWidget {
  static const String id = 'SignUp';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _globalKey = GlobalKey<ScaffoldState>();
  Icon icon = Icon(Icons.remove_red_eye);
  bool seePassword = true;
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _name, _imageUrl;
  bool hidebutton = true, ignore = false;
  final _auth = FirebaseAuth.instance;
  double opacity = 1;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  void _hideButton() {
    setState(() {
      hidebutton = false;
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot your Password?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'confirm the email address and we will send you a link to change your password:'),
                Text(
                  _email?? 'no email add',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Confirm'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  try {
                    await _auth.sendPasswordResetEmail(email: _email);
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
                  Navigator.of(context).pop();
                }

                _globalKey.currentState.showSnackBar(
                  SnackBar(
                    content: Container(
                        child: Text(
                      'Please enter your email',
                      textAlign: TextAlign.center,
                    )),
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        _email = user.email;
        _imageUrl = user.photoURL;
        Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
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
    return user;
  }

  Future<void> _sigInWithEmail(BuildContext context) async {
    FocusScope.of(context).unfocus();
    setState(() {
      opacity = 0.7;
      ignore = true;
    });
    if (_formKey.currentState.validate()) {
      dynamic _signIn;
      try {
        _signIn = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
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
      try {
        if (_signIn != null) {
        Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
          setState(() {
            opacity = 1;
            ignore = false;
          });
        }
      } catch (e) {
        FlutterError('Something went wrong on autentication');
      }
      setState(() {
        opacity = 1;
        ignore = false;
      });
    }
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
                'Sign In',
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
                            label: 'Continue with Google',
                            labelColor: Colors.white,
                            onPressed: () => _signWithGoogle(),
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
                          return 'Password must be at least 6 characters';
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
                        labelText: 'Password',
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
                    label: 'Sign in with email',
                    labelColor: Colors.black,
                    onPressed: () => _sigInWithEmail(context),
                  ),
                ),
                Column(
                  children: [
                    FlatButton(
                        onPressed: () => _showMyDialog(),
                        child: Text(
                          'forgot your password?',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 16),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
