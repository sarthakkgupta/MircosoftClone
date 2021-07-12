import 'package:agora_flutter_quickstart/src/utils/auth.dart';
import 'package:agora_flutter_quickstart/widgets.dart/signinbutton.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: h * 0.1,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Microsoft Teams*',
                style: TextStyle(color: Color(0xff6264A2), fontSize: 20),
              ),
            ),
            Container(
                child: Image(
              image: AssetImage('assets/icon1.png'),
              width: w * 0.7,
              height: h * 0.2,
            )),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Get closer to friends,family or co-workers',
                style: TextStyle(
                  color: Color(0xff6264A2),
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: h * 0.05,
            ),
            SizedBox(
              height: h * 0.025,
            ),
            FutureBuilder(
              future: Authentication.initializeFirebase(context: context),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error initializing Firebase');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return GoogleSignInButton();
                }
                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
