import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dribbbledanimation/Screens/social/chatsRc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './TweetHelper.dart';
import './TweetItemModel.dart';
import './header.dart';
import './headerAfiliados.dart';
import 'headerBarHome.dart';
import 'package:http/http.dart' as http;
import '../../homeScreen.dart';
//import './head';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UserFeedPage extends StatefulWidget {
  final String usuario;
  final int tipo;
  final String fotoPerfil;
  UserFeedPage(this.usuario, this.fotoPerfil, this.tipo) {
    print("UserFeedPage");
    print(tipo);
  }
  @override
  State<StatefulWidget> createState() {
    return _UserFeedPageState();
  }
}

class _UserFeedPageState extends State<UserFeedPage> {
  var selectedPageIndex = 0;
  String nombres;
  List<Map<String, String>> registrosEncontrado;
  Future<File> imageFile;
  pickImageFromGallery(ImageSource source) {
    print("tipo");
    print(widget.tipo);
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  _getAfiliados(nombresA) {
    print(nombresA);
    setState(() {
      nombres = nombresA;
    });
    /*var url = 'http://teamtravel.agencyth.online:8080/sri/nombres/${nombres}';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        //  registrosEncontrado = response.body;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }*/
  }

  Future<List<Persona>> fetchPersonas(http.Client client) async {
    final response = await client
        .get('http://teamtravel.agencyth.online:8080/sri/nombres/${nombres}');

    // Use the compute function to run parsePhotos in a separate isolate.
    return parsePersonas(response.body);
  }

  List<Persona> parsePersonas(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Persona>((json) => Persona.fromJson(json)).toList();
  }

  _getCabecera() {
    switch (widget.tipo) {
      case 1:
        return HeaderBarAfiliados(
            widget.usuario, widget.fotoPerfil, widget.tipo, _getAfiliados);
      default:
        return HeaderBarHome(widget.usuario, widget.fotoPerfil, widget.tipo);
    }
  }

  _getBody() {
    switch (widget.tipo) {
      case 1:
        return FutureBuilder<List<Persona>>(
          future: fetchPersonas(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? PersonaList(persona: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        );
      default:
        return ChatsRc();
    }
  }

  @override
  Widget build(BuildContext context) {
    return /*Scaffold(
      body:*/
        NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
              expandedHeight: 350.0,
              //floating: true,
              //title: Text("Comenta!"),
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(background: _getCabecera())),
        ];
      },
      body: _getBody(),
      /*,*/
    );

    //   );
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

class Persona {
  final String identificacion;
  final String nombreCompleto;
  final String fechaDefuncion;

  Persona({this.identificacion, this.nombreCompleto, this.fechaDefuncion});

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      identificacion: json['identificacion'] as String,
      nombreCompleto: json['nombreCompleto'] as String,
      fechaDefuncion: json['fechaDefuncion'] as String,
    );
  }
}

class PersonaList extends StatelessWidget {
  final List<Persona> persona;

  PersonaList({Key key, this.persona}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: persona.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      color: Colors.green,
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
                                      text: persona[index].identificacion,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.0,
                                          color: Colors.black),
                                    ),
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
                            persona[index].nombreCompleto,
                            style: TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: persona[index].fechaDefuncion != null
                                      ? "Fecha de Defunción: " +
                                          persona[index].fechaDefuncion
                                      : "",
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.red))
                            ]))),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.affiliatetheme,
                                color: Colors.blue,
                              ),
                              Icon(
                                FontAwesomeIcons.shareAlt,
                                color: Colors.blue,
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
  }
}
