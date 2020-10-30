import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HeaderBar extends StatefulWidget {
  final String usuario;
  var fotoPerfil;
  HeaderBar(this.usuario, this.fotoPerfil);
  @override
  _HeaderBarState createState() => _HeaderBarState(usuario, fotoPerfil);
}

class _HeaderBarState extends State<HeaderBar> {
  final double appBarHeight = 66.0;
  final myController = TextEditingController();
  final String usuario;
  var fotoPerfil;
  _HeaderBarState(this.usuario, this.fotoPerfil);
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
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
            Text("MANTENTE INFORMADO CON LAS ÚTLIMAS PUBLICACIONES",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Literata'),
                textAlign: TextAlign.center),
            TextField(
              controller: myController,
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
                  tooltip: 'Ingresar un comentario',
                  onPressed: () {
                    if (myController.text.length > 0) {
                      Firestore.instance
                          .collection('noticias')
                          .document()
                          .setData({
                        'username': usuario,
                        'tweet': myController.text,
                        'twitterHandle': '@test',
                        'fotoPerfil': fotoPerfil == false ? "" : fotoPerfil,
                        'time': new DateTime.now()
                      });
                      myController.clear();
                    }
                  },
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
