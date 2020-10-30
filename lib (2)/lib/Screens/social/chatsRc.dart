import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class ChatsRc extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatsRcState();
}

class _ChatsRcState extends State<ChatsRc> {
  File _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('noticias')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        //return _buildList(context, snapshot.data.documents);
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, position) {
            DocumentSnapshot data = snapshot.data.documents.elementAt(position);
            final chatRecibido = Record.fromSnapshot(data);
            // TweetItemModel tweet = TweetHelper.getTweet(position);

            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: chatRecibido.fotoPerfil != ""
                            ? Image.network(chatRecibido.fotoPerfil,
                                width: 60, height: 60)
                            : Icon(
                                Icons.account_circle,
                                size: 60.0,
                                color: Colors.grey,
                              ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: chatRecibido.username,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18.0,
                                              color: Colors.black),
                                        ),
                                        TextSpan(
                                            text: " " +
                                                chatRecibido.twitterHandle,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.grey)),
                                      ]),
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    flex: 5,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: Icon(
                                        Icons.expand_more,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    flex: 1,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: " ${chatRecibido.time}",
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.grey))
                                ]))),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                chatRecibido.tweet,
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.comment,
                                    color: Colors.grey,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.retweet,
                                    color: Colors.grey,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.heart,
                                    color: Colors.grey,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.share,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () async {
                                      await _shareImage();
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _shareText() async {
    try {
      Share.text('my text title',
          'This is my text to share with other applications.', 'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareImage() async {
    try {
      final ByteData bytes = await rootBundle.load('assets/login.jpg');
      await Share.file(
          'esys image', 'esys.png', bytes.buffer.asUint8List(), 'image/jpg',
          text: 'My optional text.');
    } catch (e) {
      print('error: $e');
    }
  }
}

class Record {
  final String name;
  final int votes;
  final String username;
  final String twitterHandle;
  final String tweet;
  final String time;
  final String fotoPerfil;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        votes = map['votes'],
        username = map['username'],
        twitterHandle = map['twitterHandle'],
        tweet = map['tweet'],
        fotoPerfil = map['fotoPerfil'],
        time = DateFormat().format((map['time'].toDate().toLocal()));
  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$votes>";
}
