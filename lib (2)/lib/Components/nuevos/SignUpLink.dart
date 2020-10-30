import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  final Function procesar;
  SignUp({this.procesar});
  @override
  Widget build(BuildContext context) {
    return (new FlatButton(
      onPressed: () {
        debugPrint('Console Message Using Debug Print');

        // loginUser(phone, context);
      },
      child: new Text(
        "No tienes una cuenta? Regístrate",
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: new TextStyle(
            // fontWeight: FontWeight.w300,
            letterSpacing: 0.5,
            color: Colors.white,
            fontSize: 17.0),
      ),
    ));
  }
}
