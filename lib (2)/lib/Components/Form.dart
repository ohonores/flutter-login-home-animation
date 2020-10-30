import 'package:dribbbledanimation/Components/SignInButton.dart';
import 'package:flutter/material.dart';
import './InputFields.dart';
import 'package:dribbbledanimation/Components/Auth.dart';
import 'package:dribbbledanimation/Screens/dashboard/menu_dashboard_layout.dart';

class FormContainer extends StatelessWidget {
  final usuarioController;
  final passwordController;
  final Function animar;
  final Function procesar;
  FormContainer(
      {this.usuarioController,
      this.animar,
      this.passwordController,
      this.procesar});

  @override
  Widget build(BuildContext context) {
    return (new Container(
      margin: new EdgeInsets.symmetric(horizontal: 20.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Form(
              child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new InputFieldArea(
                hint: "Username",
                obscure: false,
                icon: Icons.person_outline,
                controlador: usuarioController,
              ),
              new InputFieldArea(
                hint: "Password",
                obscure: true,
                icon: Icons.lock_outline,
                controlador: passwordController,
              ),
              new InkWell(
                  onTap: () {
                    // animar();
                    procesar(true);
                    Auth()
                        .signIn(usuarioController.text.toString(),
                            passwordController.text.toString(), context)
                        .then((value) => {procesar(false)}, onError: (e) {
                      debugPrint(e);
                    });

                    //_playAnimation();
                  },
                  child: new SignIn())
            ],
          )),
        ],
      ),
    ));
  }
}
