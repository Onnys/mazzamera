
import 'package:flutter/material.dart';
import 'package:mazzamera/components/button.dart';
import 'package:mazzamera/screens/signUp.dart';
import 'package:mazzamera/screens/signIn.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'WelcomeScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blue.jpg'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Align(
              alignment: Alignment.center,
            
              child: Text('Mazzamera',
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontFamily: 'Rajdhani',
                      fontWeight: FontWeight.bold)),
            )),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Have fun with Mozambican Memes.\n Made by Moz for Moz with love.', 
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Rajdhani',
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Button(hasIcon: false, color: Colors.white, label: 'Create an account', labelColor: Colors.black, onPressed: ()=>{
              Navigator.pushNamed(context, Login.id)
            },),
            Button(hasIcon: false,color: Colors.blueGrey, label: 'I already have an account', labelColor: Colors.white, onPressed: ()=>{Navigator.pushNamed(context, SignIn.id)},)
          ],
        ),
      ),
    );
  }
}
