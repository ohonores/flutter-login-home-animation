import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import '../../helper/constant.dart';
import '../../helper/enum.dart';
import '../../helper/theme.dart';
import '../../helper/utility.dart';
import '../../model/user.dart';
import '../../page/Auth/widget/googleLoginButton.dart';
import '../../state/authState.dart';
import '../../widgets/customWidgets.dart';
import '../../widgets/newWidget/customLoader.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  final VoidCallback loginCallback;

  const Signup({Key key, this.loginCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmController;

  Persona persona;
  String nombres = "";
  CustomLoader loader;
  Future<Persona> _futurePersoa;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    loader = CustomLoader();
    _nameController = TextEditingController();
    _nameController.addListener(_vaciar);
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    super.initState();
  }

  _vaciar() {
    print(_nameController.text);
    setState(() {
      nombres = "";
    });
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<Persona> buscarPersonaNatural(
      String identificacion, String tipo) async {
    final client = http.Client();
    print(identificacion);
    try {
      final response = await client.get(
          'https://us-central1-alien20025.cloudfunctions.net/getIdentificacion/${identificacion}/${tipo}');
      print(response.body);
      if (response.statusCode == 200) {
        return parsePersona(response.body);
      } else {
        throw Exception('Identificación no encontrada');
      }
      // Use the compute function to run parsePhotos in a separate isolate.

    } catch (e) {
      throw Exception('Identificación no encontrada');
    } finally {
      client.close();
    }
  }

  Future buscarPersonaJuridica(http.Client client) async {
    final response = await client.get(
        'https://us-central1-alien20025.cloudfunctions.net/getIdentificacion/${_nameController.text}/J');

    // Use the compute function to run parsePhotos in a separate isolate.
    parsePersona(response.body);
  }

  Persona parsePersona(String responseBody) {
    print(responseBody);
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    print(parsed);

    return Persona.fromJson(parsed['contribuyente']);
  }

  Widget _body(BuildContext context) {
    return Expanded(
      child: Container(
          height: fullHeight(context),
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _entryFeild('Identificación', controller: _nameController),
                _entryFeild('Email',
                    controller: _emailController, isEmail: true),
                // _entryFeild('Mobile no',controller: _mobileController),
                _entryFeild('Password',
                    controller: _passwordController, isPassword: true),
                _entryFeild('Password',
                    controller: _confirmController, isPassword: true),
                _submitButton(context),

                //Divider(height: 30),
                //SizedBox(height: 30),
                // _googleLoginButton(context),
                /* GoogleLoginButton(
              loginCallback: widget.loginCallback,
              loader: loader,
            ),*/
                //SizedBox(height: 30),
              ],
            ),
          )),
    );
  }

  Widget _entryFeild(String hint,
      {TextEditingController controller,
      bool isPassword = false,
      bool isEmail = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        //   onChanged: _vaciar(),
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          errorText: hint == "Identificación" ? nombres : "",
          errorStyle: TextStyle(color: Colors.blue.withOpacity(1.0)),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
            borderSide: BorderSide(color: Colors.blue),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: TwitterColor.dodgetBlue,
        onPressed: _submitForm,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _googleLogin() {
    var state = Provider.of<AuthState>(context, listen: false);
    if (state.isbusy) {
      return;
    }
    loader.showLoader(context);
    state.handleGoogleSignIn().then((status) {
      // print(status)
      if (state.user != null) {
        loader.hideLoader();
        Navigator.pop(context);
        widget.loginCallback();
      } else {
        loader.hideLoader();
        cprint('Unable to login', errorIn: '_googleLoginButton');
      }
    });
  }

  void _submitForm() {
    if (_emailController.text.isEmpty) {
      customSnackBar(_scaffoldKey, 'Por fovor ingrese el email');
      return;
    }
    buscarPersonaNatural(_nameController.text, "N").then((perosna) {
      customSnackBar(_scaffoldKey, "Nombres>> " + perosna.nombreCompleto);
      setState(() {
        nombres = perosna.nombreCompleto;
      });
      if (_emailController.text.length > 27) {
        customSnackBar(
            _scaffoldKey, 'El email no puede exceder de los 100 caracteres');
        return;
      }
      if (_emailController.text == null ||
          _emailController.text.isEmpty ||
          _passwordController.text == null ||
          _passwordController.text.isEmpty ||
          _confirmController.text == null) {
        customSnackBar(_scaffoldKey, 'Por favor llene el formulario');
        return;
      } else if (_passwordController.text != _confirmController.text) {
        customSnackBar(
            _scaffoldKey, 'El password no concide con la confirmación');
        return;
      }
      _grabarUsuario(perosna);
    }).catchError((e) {
      print(e);
      customSnackBar(_scaffoldKey, e.toString());
      setState(() {
        nombres = "";
      });
    });
  }

  void _grabarUsuario(Persona perosna) {
    loader.showLoader(context);
    var state = Provider.of<AuthState>(context, listen: false);
    Random random = new Random();
    int randomNumber = random.nextInt(8);
    print("_grabarUsuario");
    print(perosna);
    User user = User(
        email: _emailController.text.toLowerCase(),
        bio: 'Edit profile to update bio',
        // contact:  _mobileController.text,
        displayName: perosna.nombreCompleto,
        userName: _emailController.text.toLowerCase().split("@")[0],
        dob: DateTime(1950, DateTime.now().month, DateTime.now().day + 3)
            .toString(),
        location: 'Somewhere in universe',
        profilePic: dummyProfilePicList[randomNumber],
        isVerified: false,
        userId: perosna.identificacion);
    state
        .signUp(
      user,
      password: _passwordController.text,
      scaffoldKey: _scaffoldKey,
    )
        .then((status) {
      print(status);
    }).whenComplete(
      () {
        loader.hideLoader();
        if (state.authStatus == AuthStatus.LOGGED_IN) {
          Navigator.pop(context);
          widget.loginCallback();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: customText(
          'RC APP :: Sign Up',
          context: context,
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: _body(context)),
    );
  }
}

class Persona {
  final String identificacion;
  final String nombreCompleto;
  final String deuda;
  final String error;
  final String mensaje;
  Persona(
      {this.identificacion,
      this.nombreCompleto,
      this.deuda,
      this.error,
      this.mensaje});
  //Persona({this.error});
  factory Persona.fromJson(Map<String, dynamic> json) {
    print(json);
    return Persona(
      identificacion: json['identificacion'] as String,
      nombreCompleto: json['nombreComercial'] as String,
      deuda: json['deuda'] as String,
      error: json['error'] as String,
      mensaje: json['mensaje'] as String,
    );
  }
}
