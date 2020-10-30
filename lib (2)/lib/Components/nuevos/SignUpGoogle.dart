import 'package:dribbbledanimation/Screens/Home/inicio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dribbbledanimation/homeScreen.dart';

class SignUpGoogle extends StatelessWidget {
  final Function procesar;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
/*final FirebaseAuth _auth = FirebaseAuth.instance;*/
  SignUpGoogle({this.procesar});
  void onGoogleSignIn(BuildContext context) async {
    procesar(true);
    FirebaseUser user = await _handleSignIn().catchError((e) {
      print("Error al autentificarse *************");
      procesar(false);
      final alert = AlertDialog(
        title: Text("Error"),
        content: Text(
            "Se encontró un error al acceder a Gmail, por favor vuelva a intentarlo."),
        actions: [
          FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    });
    if (user == null) {
      print("no se logro autenticar el usario es null");
      procesar(false);
      final alert = AlertDialog(
        title: Text("Error"),
        content: Text(
            "Se encontró un error al acceder a Gmail, por favor vuelva a intentarlo."),
        actions: [
          FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
      return;
    }
    IdTokenResult token = await user.getIdToken();
    if (!user.isAnonymous && token != null) {
      procesar(false);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeSreenT(user)));
    } else {
      print("no se logro autenticar");
      final alert = AlertDialog(
        title: Text("Error"),
        content: Text(
            "Se encontró un error al acceder a Gmail, por favor vuelva a intentarlo."),
        actions: [
          FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        /*signInWithGoogle(context).whenComplete(() {
          print("fin**************");
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return HomeSreenT();
              },
            ),
          );
        });*/
        onGoogleSignIn(context);
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
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
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

  Future<FirebaseUser> _handleSignIn() async {
    // hold the instance of the authenticated user
    FirebaseUser user;
    // flag to check whether we're signed in already
    bool isSignedIn = await _googleSignIn.isSignedIn();
    print("_handleSignIn ");
    print("_handleSignIn " + isSignedIn.toString());
    if (isSignedIn) {
      //signOutGoogle();
      //FirebaseAuth.instance.signOut();
      // if so, return the current user

      user = await _auth.currentUser();
      if (user == null) {
        signOutGoogle();
      }
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // get the credentials to (access / id token)
      // to sign in via Firebase Authentication
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      user = (await _auth.signInWithCredential(credential)).user;
    }

    return user;
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    //Navigator.of(context).pop();
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    IdTokenResult token = await user.getIdToken();
    if (!user.isAnonymous && token != null) {
      print("conectado");
      print("token");
      print(token);
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return HomeSreenT(user);
          },
        ),
      );
    }

    //assert(user.uid == currentUser.uid);
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }
}
