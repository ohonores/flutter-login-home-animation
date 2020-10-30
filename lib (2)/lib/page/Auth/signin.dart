import 'package:dribbbledanimation/Components/InputFields.dart';
import 'package:dribbbledanimation/Components/nuevos/WhiteTick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../helper/theme.dart';
import '../../helper/utility.dart';
import '../../page/Auth/widget/googleLoginButton.dart';
import '../../state/authState.dart';
import '../../widgets/customWidgets.dart';
import '../../widgets/newWidget/customLoader.dart';
import '../../widgets/newWidget/title_text.dart';
import 'package:provider/provider.dart';
import '../../page/homePage.dart';

class SignIn extends StatefulWidget {
  final VoidCallback loginCallback;

  const SignIn({Key key, this.loginCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  CustomLoader loader;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    loader = CustomLoader();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _body(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return (new WillPopScope(
        child: new Scaffold(
            body: new Container(
      decoration: new BoxDecoration(
        image: backgroundImage,
      ),
      child: new Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
          colors: <Color>[
            const Color.fromRGBO(248, 248, 248, 0.8),
            const Color.fromRGBO(51, 51, 63, 0.9),
          ],
          stops: [0.2, 1.0],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        )),
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Tick(image: tick),
            InputFieldArea(
              hint: "Username",
              obscure: false,
              icon: Icons.person_outline,
              controlador: _emailController,
            ),
            InputFieldArea(
              hint: "Password",
              obscure: false,
              icon: Icons.person_outline,
              controlador: _passwordController,
            ),

            _emailLoginButton(context),
            //SizedBox(height: 10),
            /* _labelButton('Forget password?', onPressed: () {
              Navigator.of(context).pushNamed('/ForgetPasswordPage');
            }),*/
            GoogleLoginButton(
              loginCallback: widget.loginCallback,
              loader: loader,
            ),
            //   SizedBox(height: 100),
          ],
        ),
      ),
    ))));
  }

  Widget _entryFeild(String hint,
      {TextEditingController controller, bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: Colors.blue)),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Widget _labelButton(String title, {Function onPressed}) {
    return FlatButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      splashColor: Colors.grey.shade200,
      child: Text(
        title,
        style: TextStyle(
            color: TwitterColor.dodgetBlue, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _emailLoginButton(BuildContext context) {
    return Container(
      width: fullWidth(context),
      //   margin: EdgeInsets.symmetric(vertical: 35),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: const Color.fromRGBO(0, 128, 100, 1.0),
        onPressed: _emailLogin,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: TitleText('Sign In', color: Colors.white),
      ),
    );
  }

  void _emailLogin() {
    var state = Provider.of<AuthState>(context, listen: false);
    if (state.isbusy) {
      return;
    }
    loader.showLoader(context);
    var isValid = validateCredentials(
        _scaffoldKey, _emailController.text, _passwordController.text);
    if (isValid) {
      state
          .signIn(_emailController.text, _passwordController.text,
              scaffoldKey: _scaffoldKey)
          .then((status) {
        if (state.user != null) {
          loader.hideLoader();
          Navigator.pop(context);
          widget.loginCallback();
        } else {
          cprint('Unable to login', errorIn: '_emailLoginButton');
          loader.hideLoader();
        }
      });
    } else {
      loader.hideLoader();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      /*appBar: AppBar(
        title: customText('Sign in',
            context: context, style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),*/
      body: _body(context),
    );
  }
}

DecorationImage backgroundImage = new DecorationImage(
  image: new ExactAssetImage('assets/RC_APP.jpeg'),
  fit: BoxFit.cover,
);

DecorationImage tick = new DecorationImage(
  image: new ExactAssetImage('assets/logo_rcpng.png'),
  fit: BoxFit.cover,
);
