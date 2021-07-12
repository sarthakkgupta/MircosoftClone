import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  Createstate createState() => Createstate();
}

class Createstate extends State<CreateRoom> {
  final _roomNameController = TextEditingController();
  final _passController = TextEditingController();
  bool _validateError = false;
  bool _validatePass = false;

  /// create a channelController to retrieve text valu
  @override

  /// if channel textField is validated to have error
  Widget build(BuildContext context) {
    _passController.text = ' ';
    //   CollectionReference room = FirebaseFirestore.instance.collection(_roomNameController.text);
    Future<void> onSubmit() async {
      setState(() {
        _roomNameController.text.isEmpty
            ? _validateError = true
            : _validateError = false;
        _passController.text.isEmpty
            ? _validatePass = true
            : _validatePass = false;
      });
      if (!_validateError && !_validatePass) {
        FirebaseFirestore.instance
            .collection(widget._user.uid)
            .add({
              'RoomName': _roomNameController.text, // John Doe
              'password': _passController.text, // Stokes and Sons
            })
            .then((value) => print("Room Added"))
            .catchError((error) => print("Failed to add room: $error"));
        // Call the user's CollectionReference to add a new user
        return FirebaseFirestore.instance
            .collection(_roomNameController.text)
            .add({
              'RoomName': _roomNameController.text, // John Doe
              'password': _passController.text, // Stokes and Sons
            })
            .then((value) => print("Room Added"))
            .catchError((error) => print("Failed to add room: $error"));
      }
    }

    Future<void> onSubmit2() async {
      setState(() {
        _roomNameController.text.isEmpty
            ? _validateError = true
            : _validateError = false;
        _passController.text.isEmpty
            ? _validatePass = true
            : _validatePass = false;
      });
      if (!_validateError && !_validatePass) {
        FirebaseFirestore.instance
            .collection(widget._user.uid)
            .add({
              'RoomName': _roomNameController.text, // John Doe
              'password': _passController.text, // Stokes and Sons
            })
            .then((value) => print("Room Added"))
            .catchError((error) => print("Failed to add room: $error"));
        // Call the user's CollectionReference to add a new user
        return FirebaseFirestore.instance
            .collection(_roomNameController.text)
            .add({
              'RoomName': _roomNameController.text, // John Doe
              'password': _passController.text, // Stokes and Sons
            })
            .then((value) => print("Room Added"))
            .catchError((error) => print("Failed to add room: $error"));
      }
    }

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: h * 0.25,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        controller: _roomNameController,
                        maxLength: 10,
                        showCursor: false,
                        decoration: InputDecoration(
                            errorText: _validateError
                                ? 'Room name is mandatory'
                                : null,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1),
                            ),
                            hintText: 'Team name',
                            counterText: ''),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  InkWell(
                    onTap: () => {
                      onSubmit(),
                      if (!_validateError && !_validatePass)
                        Navigator.pop(context)
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: w * 0.8,
                        child: Text(
                          'Create Team',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xff6264A2))),
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  InkWell(
                    onTap: () => {
                      onSubmit(),
                      if (!_validateError && !_validatePass)
                        Navigator.pop(context)
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: w * 0.8,
                        child: Text(
                          'Join Team',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xff6264A2))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
