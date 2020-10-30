import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './TweetHelper.dart';
import './TweetItemModel.dart';
import './header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Afiliados extends StatefulWidget {
  final String usuario;
  var fotoPerfil;
  Afiliados(this.usuario, this.fotoPerfil);
  @override
  _AfiliadosState createState() => _AfiliadosState(usuario, fotoPerfil);
}

class _AfiliadosState extends State<Afiliados> {
  final String usuario;
  var fotoPerfil;
  _AfiliadosState(this.usuario, this.fotoPerfil);
  var selectedPageIndex = 0;
  Future<File> imageFile;
  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                //floating: true,
                //title: Text("Comenta!"),
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                    /* centerTitle: true,
                  title: Text("Collapsing Toolbar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),*/
                    background: HeaderBar(usuario, fotoPerfil)),
              ),
            ];
          },
          body: _buildBody(context)),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            title: Text(""),
            icon: Icon(
              FontAwesomeIcons.home,
              color: selectedPageIndex == 0 ? Colors.blue : Colors.blueGrey,
            ),
          ),
          BottomNavigationBarItem(
            title: Text(""),
            icon: Icon(
              FontAwesomeIcons.search,
              color: selectedPageIndex == 1 ? Colors.blue : Colors.blueGrey,
            ),
          ),
          BottomNavigationBarItem(
              title: Text(""),
              icon: Icon(
                FontAwesomeIcons.bell,
                color: selectedPageIndex == 2 ? Colors.blue : Colors.blueGrey,
              )),
          BottomNavigationBarItem(
            title: Text(""),
            icon: Icon(
              FontAwesomeIcons.envelope,
              color: selectedPageIndex == 3 ? Colors.blue : Colors.blueGrey,
            ),
          ),
        ],
        onTap: (index) {
          print(index);
          pickImageFromGallery(ImageSource.gallery);
        },
        currentIndex: selectedPageIndex,
      ),
    );

    /*Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(150.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  decoration: InputDecoration(
                      labelText: 'COMPARTE TUS IDEAS',
                      contentPadding: const EdgeInsets.all(20.0)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.blue,
                      ),
                      tooltip: 'Increase volume by 10',
                      onPressed: () {
                        print("=");
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add_photo_alternate,
                        color: Colors.blue,
                      ),
                      tooltip: 'Increase volume by 10',
                      onPressed: () {
                        print("=");
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add_location,
                        color: Colors.blue,
                      ),
                      tooltip: 'Increase volume by 10',
                      onPressed: () {
                        print("=");
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
                      tooltip: 'Increase volume by 10',
                      onPressed: () {
                        print("=");
                      },
                    ),
                  ],
                )
              ],
            ),
            elevation: 5.0,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
          )),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, position) {
          TweetItemModel tweet = TweetHelper.getTweet(position);

          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                      child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: tweet.username,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0,
                                            color: Colors.black),
                                      ),
                                      TextSpan(
                                          text: " " + tweet.twitterHandle,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey)),
                                      TextSpan(
                                          text: " ${tweet.time}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey))
                                    ]),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                  flex: 5,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
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
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              tweet.tweet,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                Icon(
                                  FontAwesomeIcons.shareAlt,
                                  color: Colors.grey,
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            title: Text(""),
            icon: Icon(
              FontAwesomeIcons.home,
              color: selectedPageIndex == 0 ? Colors.blue : Colors.blueGrey,
            ),
          ),
          BottomNavigationBarItem(
            title: Text(""),
            icon: Icon(
              FontAwesomeIcons.search,
              color: selectedPageIndex == 1 ? Colors.blue : Colors.blueGrey,
            ),
          ),
          BottomNavigationBarItem(
              title: Text(""),
              icon: Icon(
                FontAwesomeIcons.bell,
                color: selectedPageIndex == 2 ? Colors.blue : Colors.blueGrey,
              )),
          BottomNavigationBarItem(
            title: Text(""),
            icon: Icon(
              FontAwesomeIcons.envelope,
              color: selectedPageIndex == 3 ? Colors.blue : Colors.blueGrey,
            ),
          ),
        ],
        onTap: (index) {},
        currentIndex: selectedPageIndex,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(FontAwesomeIcons.featherAlt),
      ),
    );*/
  }

  Widget _buildBody(BuildContext context) {
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
            final tweet = Record.fromSnapshot(data);
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
                        child: tweet.fotoPerfil != ""
                            ? Image.network(tweet.fotoPerfil,
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
                                          text: tweet.username,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18.0,
                                              color: Colors.black),
                                        ),
                                        TextSpan(
                                            text: " " + tweet.twitterHandle,
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
                                      text: " ${tweet.time}",
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.grey))
                                ]))),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                tweet.tweet,
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
                                  Icon(
                                    FontAwesomeIcons.shareAlt,
                                    color: Colors.grey,
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
