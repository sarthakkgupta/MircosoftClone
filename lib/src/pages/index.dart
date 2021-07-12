import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import './call.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key, required User user, required String roomname})
      : _user = user,
        roomname = roomname,
        super(key: key);

  final User _user;
  final String roomname;
  @override
  IndexState createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// if channel textField is validated to have error

  ClientRole? _role = ClientRole.Broadcaster;
  // ignore: unused_field
  bool _validateError = false;
  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _channelController.text = widget.roomname;
    final w = MediaQuery.of(context).size.width;
    // final h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //         child: TextField(
              //       controller: _channelController,
              //       decoration: InputDecoration(
              //         errorText:
              //             _validateError ? 'Room name is mandatory' : null,
              //         border: UnderlineInputBorder(
              //           borderSide: BorderSide(width: 1),
              //         ),
              //         hintText: 'Room name',
              //       ),
              //     ))
              //   ],
              // ),
              Column(
                children: [
                  ListTile(
                    title: Text("Join as a speaker"),
                    leading: Radio(
                      activeColor: Color(0xff6264A2),
                      value: ClientRole.Broadcaster,
                      groupValue: _role,
                      onChanged: (ClientRole? value) {
                        setState(() {
                          _role = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Join as a audience'),
                    leading: Radio(
                      activeColor: Color(0xff6264A2),
                      value: ClientRole.Audience,
                      groupValue: _role,
                      onChanged: (ClientRole? value) {
                        setState(() {
                          _role = value;
                        });
                      },
                    ),
                  )
                ],
              ),
              InkWell(
                onTap: () => onJoin(),
                child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: w * 0.8,
                    child: Text(
                      'Join Call',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    decoration: BoxDecoration(
                        // gradient: LinearGradient(
                        //   begin: Alignment.centerRight,
                        //   end: Alignment
                        //       .bottomRight, // 10% of the width, so there are ten blinds.
                        //   colors: <Color>[
                        //     Color(0xff6264A2),
                        //     Color(0xffDEDFFF),
                        //     Color(0xff6264A2),
                        //   ], // red to yellow
                        // ),
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xff6264A2))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given Room name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            user: widget._user,
            channelName: _channelController.text,
            role: _role,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
