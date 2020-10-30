import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HeaderBarAfiliados extends StatefulWidget {
  final String usuario;
  final String fotoPerfil;
  final int tipo;
  final Function _getAfiliados;
  HeaderBarAfiliados(
      this.usuario, this.fotoPerfil, this.tipo, this._getAfiliados);
  @override
  State<StatefulWidget> createState() => _HeaderBarAfiliadosState();
}

class _HeaderBarAfiliadosState extends State<HeaderBarAfiliados> {
  final double appBarHeight = 66.0;
  final myController = TextEditingController();
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
            Image.asset(
              "assets/iconos/logo.png",
              height: 130,
              width: 130,
            ),
            Text("Afliar miembros",
                style: TextStyle(
                    fontSize: 14, fontFamily: 'Colibri', color: Colors.blue)),
            TextField(
                controller: myController,
                keyboardType: TextInputType.multiline,
                //maxLines: null,
                decoration: InputDecoration(
                    //filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        widget._getAfiliados(myController.text);
                        /*if (myController.text.length > 0) {
                          Firestore.instance
                              .collection('noticias')
                              .document()
                              .setData({
                            'username': widget.usuario,
                            'tweet': myController.text,
                            'twitterHandle': '@test',
                            'fotoPerfil': widget.fotoPerfil != null
                                ? widget.fotoPerfil
                                : "",
                            'time': new DateTime.now()
                          });
                          myController.clear();
                        }*/
                      },
                    ),
                    fillColor: Colors.white,
                    hintText: 'Ingrese los nombres a afiliar',
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
          ],
        ),
      ),
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
    );
  }
}
