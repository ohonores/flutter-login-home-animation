import 'package:dribbbledanimation/Screens/Home/inicio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dribbbledanimation/homeScreen.dart';
import 'package:dribbbledanimation/Components/Auth.dart';

class SignUpNumberTelefono extends StatefulWidget {
  final Function procesar;
  SignUpNumberTelefono({this.procesar});
  @override
  _SignUpNumberTelefonoState createState() =>
      _SignUpNumberTelefonoState(procesar: procesar);
}

class _SignUpNumberTelefonoState extends State<SignUpNumberTelefono> {
  final myController = TextEditingController();
  final Function procesar;
  _SignUpNumberTelefonoState({this.procesar});

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        _showDialog(context);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(
              Icons.call,
              color: Colors.green,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with CellPhone',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _showDialog(BuildContext context) async {
    await showDialog<String>(
      context: context,
      child: new _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  controller: myController,
                  decoration: new InputDecoration(
                      labelText: 'Número de téfeno celular',
                      hintText: 'eg. 0993395754'),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  procesar(false);
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('ENVIAR'),
                onPressed: () {
                  procesar(true);
                  Navigator.pop(context);
                  Auth()
                      .loginUserByCellPhone(
                          myController.text.toString(), context, procesar)
                      .then((value) => {procesar(false)}, onError: (e) {
                    debugPrint(e);
                  });

                  //Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
