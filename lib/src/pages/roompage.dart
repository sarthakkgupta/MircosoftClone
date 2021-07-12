import 'package:agora_flutter_quickstart/src/pages/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({
    Key? key,
    required User user,
    required String teamName,
    required bool durvideocall,
  })  : _user = user,
        _teamName = teamName,
        _durvideocall = durvideocall,
        super(key: key);
  final bool _durvideocall;
  final User _user;
  final String _teamName;
  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();
  final _roomNameController = TextEditingController();
  bool _validateError = false;
  Future<void> onSubmit() async {
    setState(() {
      _roomNameController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (!_validateError) {
      // Call the user's CollectionReference to add a new user
      return FirebaseFirestore.instance
          .collection(widget._teamName)
          .doc('messages')
          .collection("Messages")
          .add({
            'Name': widget._user.displayName,
            'Message': _roomNameController.text,
            'DateTime': DateTime.now(),
            'photo': widget._user.photoURL,
          })
          .then((value) => print("Room Added"))
          .catchError((error) => print("Failed to add room: $error"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    final h = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight) -
        bottomInsets;
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection(widget._teamName)
        .doc('messages')
        .collection("Messages")
        .orderBy('DateTime', descending: true)
        .snapshots();
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget._teamName),
        actions: [
          if (!widget._durvideocall)
            InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IndexPage(
                          user: widget._user, roomname: widget._teamName))),
              child: Icon(
                Icons.video_call,
                color: Colors.amber,
              ),
            ),
          SizedBox(
            width: 5,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return SizedBox(
                  height: h * 0.85,
                  width: w,
                  child: ListView(
                    controller: _scrollController,
                    reverse: true,
                    //         physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      final bool msgbyuser =
                          data['Name'] == widget._user.displayName;
                      ;
                      return Container(
                        padding: EdgeInsets.all(2),
                        //   height: 50,
                        child: Row(
                          mainAxisAlignment: msgbyuser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: msgbyuser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: CircleAvatar(
                                child: Image.network(
                                  data['photo'],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.all(2),
                                alignment: msgbyuser
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: msgbyuser
                                            ? Alignment.topRight
                                            : Alignment.topLeft,
                                        end: msgbyuser
                                            ? Alignment.bottomLeft
                                            : Alignment.bottomRight,

                                        colors: <Color>[
                                          Color(0xffF9FF8E),
                                          Colors.white
                                        ], // red to yellow
                                        tileMode: TileMode
                                            .repeated, // repeats the gradient over the canvas
                                      ),
                                      border: Border.all(width: 0.5),
                                      borderRadius: BorderRadius.circular(10)),
                                  //    height: 50,
                                  width: w * 0.7,
                                  alignment: msgbyuser
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Column(children: [
                                    Align(
                                      alignment: msgbyuser
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            new TextSpan(
                                              text: msgbyuser
                                                  ? ''
                                                  : data['Name'] + '\n',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.deepPurple,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            new TextSpan(
                                              text: data['Message'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: msgbyuser
                                          ? Alignment.bottomLeft
                                          : Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          DateFormat('hh:mm aaa d MMMM y')
                                              .format(
                                                  data['DateTime'].toDate()),
                                          style: TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ]),
                                )),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            Container(
              height: h * 0.15,
              width: w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: h * 0.2,
                    width: w * 0.8,
                    child: TextField(
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      minLines: null,
                      maxLines:
                          null, // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                      expands: true,
                      controller: _roomNameController,
                      decoration: InputDecoration(
                        errorText: _validateError ? 'Message is empty' : null,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                        hintText: 'Write a message',
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => {onSubmit(), _roomNameController.text = ''},
                    child: Icon(
                      Icons.send,
                      color: Colors.amber,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
