import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mazzamera/screens/addMedia.dart';
import 'package:mazzamera/screens/mazzamera_home.dart';
import 'package:mazzamera/screens/signUp.dart';
import 'package:mazzamera/screens/signIn.dart';
import 'package:mazzamera/screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(Mazzamera());
}

class Mazzamera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Rajdhani', focusColor: Colors.black38),
      title: 'Mazzamera',
      initialRoute: (FirebaseAuth.instance.currentUser!= null)?Home.id: WelcomeScreen.id, 
      routes: ({
        WelcomeScreen.id: (context) => (FirebaseAuth.instance.currentUser!= null)?Home(): WelcomeScreen(),
        Login.id : (context) => Login(),
        SignIn.id : (context)=> SignIn(),
        Home.id: (context)=>Home(),
        AddMedia.id: (context)=> AddMedia(),
      }),
    );
  }
}

