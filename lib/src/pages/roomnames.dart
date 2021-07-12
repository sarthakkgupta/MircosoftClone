import 'package:agora_flutter_quickstart/src/pages/roompage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RoomList extends StatefulWidget {
  const RoomList({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  State<RoomList> createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection(widget._user.uid).snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text("Teams"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.length != 0) {
            Center(
              child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "No team yet create or Join a team ",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20),
                  )),
            );
          }
          return new ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RoomPage(
                                user: widget._user,
                                teamName: data['RoomName'],
                                durvideocall: false,
                              )))
                },
                child: new Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RawMaterialButton(
                        onPressed: null,
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        shape: CircleBorder(),
                        elevation: 1.0,
                        fillColor: Color(0xff6264A2),
                        padding: const EdgeInsets.all(15.0),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(20),
                          child: Text(
                            data['RoomName'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 20),
                          )),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
