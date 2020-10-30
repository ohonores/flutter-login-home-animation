import 'dart:async';
import 'package:dribbbledanimation/Screens/Home/index.dart';
import 'package:dribbbledanimation/Screens/Home/inicio.dart';
import 'package:dribbbledanimation/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password, BuildContext context);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _codeController = TextEditingController();
  Future<FirebaseUser> signIn(
      String email, String password, BuildContext context) async {
    String errorMessage;
    FirebaseUser user;
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeSreenT(user)));
      } else {
        _showDialog(context, "Error al autentificarse, usuario no encontrado!");
        print("Error");
      }
    } catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      _showDialog(context, errorMessage);
      return null;
    }
    return user;
  }

  void _showDialog(BuildContext context, String error) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error al autentificar"),
          content: new Text(error),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    _googleSignIn.signOut();
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<String> loginUserByCellPhone(
      String phone, BuildContext context, Function procesar) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    print("loginUser " + phone);
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          AuthResult result = await _auth.signInWithCredential(credential);

          FirebaseUser user = result.user;
          procesar(false);
          if (user != null) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeSreenT(user)));
            return "ok";
          } else {
            print("Error");

            return "error";
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception) {
          print("loginUser Error al autetificar" + phone);
          print(exception.message);
          _showDialog(context, exception.message);
          procesar(false);
          return "error";
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          print("loginUser codeSent" + verificationId);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Give the code?"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        procesar(true);
                        //Navigator.pop(context);
                        try {
                          final code = _codeController.text.trim();
                          AuthCredential credential =
                              PhoneAuthProvider.getCredential(
                                  verificationId: verificationId,
                                  smsCode: code);

                          AuthResult result =
                              await _auth.signInWithCredential(credential);

                          FirebaseUser user = result.user;
                          procesar(false);
                          if (user != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeSreenT(user)));
                          } else {
                            _showDialog(context,
                                "Error al autentificarse, usuario no encontrado!");
                            print("Error");
                          }
                        } catch (e) {
                          _showDialog(context,
                              "Error al autentificarse, usuario no encontrado! catch error.");
                          print(e);
                        }
                      },
                    )
                  ],
                );
              });
          return "esperar";
        },
        codeAutoRetrievalTimeout: null);
    return "";
  }
}
