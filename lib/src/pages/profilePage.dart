import 'package:agora_flutter_quickstart/auth.dart';
import 'package:agora_flutter_quickstart/src/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

Future<void> signOut({required BuildContext context}) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  try {
    if (!kIsWeb) {
      await googleSignIn.signOut();
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return SignInScreen();
        }), ModalRoute.withName('/'));
      });
    }

    await FirebaseAuth.instance.signOut();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      Authentication.customSnackBar(
        content: 'Error signing out. Try again.',
      ),
    );
  }
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Container(
              alignment: Alignment.center,
              child: Image.network(widget._user.photoURL!),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(100)),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                widget._user.displayName!,
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                widget._user.email!,
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            InkWell(
              onTap: () => {
                signOut(context: context),
                runApp(MaterialApp(
                  debugShowCheckedModeBanner: false,
                  color: Color(0xff6264A2),
                  title: 'Mircosoft Clone',
                  theme: ThemeData(
                    primaryColor: Color(0xff6264A2),
                  ),
                  home: new SignInScreen(),
                ))
              },
              child: Icon(Icons.logout),
            )
          ],
        ),
      ),
    );
  }
}
