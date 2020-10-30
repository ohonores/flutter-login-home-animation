import 'dart:async';
import 'dart:io';

import 'package:dribbbledanimation/Screens/social/image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:social_share_plugin/social_share_plugin.dart';

class HeaderBarHome extends StatefulWidget {
  final String usuario;
  final String fotoPerfil;
  final int tipo;
  HeaderBarHome(this.usuario, this.fotoPerfil, this.tipo);
  @override
  _HeaderBarHomeState createState() =>
      _HeaderBarHomeState(usuario, fotoPerfil, tipo);
}

class _HeaderBarHomeState extends State<HeaderBarHome> {
  final double appBarHeight = 66.0;
  final myController = TextEditingController();
  final String usuario;
  final int tipo;
  var fotoPerfil;
  _HeaderBarHomeState(this.usuario, this.fotoPerfil, this.tipo);

  StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile> _sharedFiles;
  String _sharedText;
  void initState() {
    super.initState();

    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      setState(() {
        print("Shared:" + (_sharedFiles?.map((f) => f.path)?.join(",") ?? ""));
        _sharedFiles = value;
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      print(value);
      print("Shared:" + (_sharedFiles?.map((f) => f.path)?.join(",") ?? ""));

      setState(() {
        _sharedFiles = value;
      });
    });
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
        print("Shared: $_sharedText");
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      setState(() {
        _sharedText = value;
        print("Shared: $_sharedText");
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    _intentDataStreamSubscription.cancel();

    super.dispose();
  }

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
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return new Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + appBarHeight,
      child: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              "assets/iconos/logo.png",
              height: 150,
              width: 150,
            ),
            Text("Adjuntar y enviar para difundir",
                style: TextStyle(
                    fontSize: 14, fontFamily: 'Literata', color: Colors.blue)),
            TextField(
                controller: myController,
                keyboardType: TextInputType.multiline,
                //maxLines: null,
                decoration: InputDecoration(
                    //filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (myController.text.length > 0) {
                          Firestore.instance
                              .collection('noticias')
                              .document()
                              .setData({
                            'username': usuario,
                            'tweet': myController.text,
                            'twitterHandle': '@test',
                            'fotoPerfil': fotoPerfil != null ? fotoPerfil : "",
                            'time': new DateTime.now()
                          });
                          myController.clear();
                        }
                      },
                    ),
                    fillColor: Colors.white,
                    hintText: 'Difunde...',
                    contentPadding: const EdgeInsets.only(
                        left: 24.0, bottom: 0.0, top: 0.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(25.7),
                    ))),
            //_image == null ? Text('No image selected.') : Image.file(_image),
            Column(
              children: <Widget>[
                Text("Shared files:"),
                Text(_sharedFiles
                        ?.map((f) =>
                            "{Path: ${f.path}, Type: ${f.type.toString().replaceFirst("SharedMediaType.", "")}\n")
                        ?.join(",") ??
                    ""),
                SizedBox(height: 100),
                Text("Shared urls/text:"),
                Text(_sharedText ?? "")
              ],
            ),
            _image == null
                ? Text('No image selected.')
                : Expanded(
                    child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (BuildContext builder, int index) {
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                _image.path,
                                fit: BoxFit.scaleDown,
                                height: 100,
                                width: 100,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("test"),
                              ),
                            ]),
                      );
                    },
                  )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.blue,
                        size: 20,
                      ),
                      tooltip: 'Increase volume by 10',
                      onPressed: () {
                        print("=");
                      },
                    ),
                    Text("Todo",
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Literata',
                            color: Colors.blue))
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.image,
                        color: Colors.blue,
                        size: 20,
                      ),
                      tooltip: 'Adjuntar imagen',
                      onPressed: getImage,
                    ),
                    Text("Imágenes",
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Literata',
                            color: Colors.blue))
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.video_library,
                        color: Colors.blue,
                        size: 20,
                      ),
                      tooltip: 'Increase volume by 10',
                      onPressed: () {
                        print("=");
                      },
                    ),
                    Text("Videos",
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Literata',
                            color: Colors.blue))
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                        size: 20,
                      ),
                      tooltip: 'Increase volume by 10',
                      onPressed: () {
                        print("=");
                      },
                    ),
                    Text("Noticias",
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Literata',
                            color: Colors.blue))
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
    );
  }
}
