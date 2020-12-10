import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../helper/utility.dart';
import '../../state/authState.dart';
import '../../widgets/customWidgets.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key}) : super(key: key);
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File _image;
  TextEditingController _name;
  TextEditingController _email;
  TextEditingController _bio;
  TextEditingController _location;
  TextEditingController _dob;
  TextEditingController _identificacion;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String dob;
  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _bio = TextEditingController();
    _location = TextEditingController();
    _dob = TextEditingController();
    _identificacion = TextEditingController();
    var state = Provider.of<AuthState>(context, listen: false);
    _name.text = "";
    _bio.text = state?.userModel?.bio;
    _email.text = state?.userModel?.email;
    _location.text = state?.userModel?.location;
    _identificacion.text = state?.userModel?.identificacion;
    _dob.text = getdob(state?.userModel?.dob);
    super.initState();
  }

  void dispose() {
    _name.dispose();
    _email.dispose();
    _bio.dispose();
    _location.dispose();
    _dob.dispose();
    _identificacion.dispose();
    super.dispose();
  }

Future<Persona> buscarPersonaNatural(
      String identificacion, String tipo) async {
    final client = http.Client();
    print(identificacion);
    try {
      showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
      });
      final response = await client.get(
          'https://us-central1-alien20025.cloudfunctions.net/getIdentificacion/${identificacion}/${tipo}');
      print(response.body);
      if (response.statusCode == 200) {
        //Navigator.pop(context);
        return parsePersona(response.body);
      } else {
        //Navigator.pop(context);
        throw Exception('Identificación no encontrada');
      }
      // Use the compute function to run parsePhotos in a separate isolate.

    } catch (e) {
      //Navigator.pop(context);
      throw Exception('Identificación no encontrada');
    } finally {
      Navigator.pop(context);
      client.close();
    }
  }

  Future buscarPersonaJuridica(http.Client client) async {
    final response = await client.get(
        'https://us-central1-alien20025.cloudfunctions.net/getIdentificacion/${_identificacion.text}/J');

    // Use the compute function to run parsePhotos in a separate isolate.
    parsePersona(response.body);
  }

  Persona parsePersona(String responseBody) {
    print(responseBody);
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    print(parsed);

    return Persona.fromJson(parsed['contribuyente']);
  }

  Widget _body() {
    var authstate = Provider.of<AuthState>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: _userImage(authstate),
              ),
            ],
          ),
        ),
        _entryIdentificacion('Identificación', controller: _identificacion, consulta:true, controllerAdd:_name),
        _entry('Nombres', controller: _name, isenable: false),
        _entry('Email', controller: _email),
        _entry('Bio', controller: _bio, maxLine: null),
        _entry('Location', controller: _location),
        InkWell(
          onTap: showCalender,
          child: _entry('Fecha de Nacimiento', isenable: false, controller: _dob),
        )
      ],
    );
  }

  Widget _userImage(AuthState authstate) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        shape: BoxShape.circle,
        image: DecorationImage(
            image: customAdvanceNetworkImage(authstate.userModel.profilePic),
            fit: BoxFit.cover),
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundImage: _image != null
            ? FileImage(_image)
            : customAdvanceNetworkImage(authstate.userModel.profilePic),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black38,
          ),
          child: Center(
            child: IconButton(
              onPressed: uploadImage,
              icon: Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _entry(String title,
      {TextEditingController controller,
      int maxLine = 1,
      bool isenable = true, bool consulta = false, TextEditingController controllerAdd}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          customText(title, style: TextStyle(color: Colors.black54)),
          TextField(
            enabled: isenable,
            controller: controller,
            maxLines: maxLine,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),)
            
        ],
      ),
    );
  }

Widget _entryIdentificacion(String title,
      {TextEditingController controller,
      int maxLine = 1,
      bool isenable = true, bool consulta = false, TextEditingController controllerAdd}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          customText(title, style: TextStyle(color: Colors.black54)),
          TextField(
            enabled: isenable,
            controller: controller,
            maxLines: maxLine,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),
            onSubmitted:   (String value) async {
              if (controller.text.isEmpty) {
      customSnackBar(_scaffoldKey, 'Por fovor ingrese su identificación');
      return;
    }
    buscarPersonaNatural(controller.text, "N").then((persona) {
      controllerAdd.text = persona.nombreCompleto;
    }).catchError((e) {
      controllerAdd.text = "";
    });
            }
          )
        ],
      ),
    );
  }

  void showCalender() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2019, DateTime.now().month, DateTime.now().day),
      firstDate: DateTime(1950, DateTime.now().month, DateTime.now().day + 3),
      lastDate: DateTime.now().add(Duration(days: 7)),
    );
    setState(() {
      if (picked != null) {
        dob = picked.toString();
        _dob.text = getdob(dob);
      }
    });
  }

  void _submitButton() {
    if (_name.text.length == 0) {
      customSnackBar(_scaffoldKey, 'Los nombres son obligatorios, por favor presione enter cuando ingrese su identificación');
      return;
    }
    if (_email.text.length == 0) {
      customSnackBar(_scaffoldKey, 'Por favor ingrese el email');
      return;
    }
    var state = Provider.of<AuthState>(context, listen: false);
    var model = state.userModel.copyWith(
      key: state.userModel.userId,
      displayName: state.userModel.displayName,
      bio: state.userModel.bio,
      contact: state.userModel.contact,
      dob: state.userModel.dob,
      email: state.userModel.email,
      location: state.userModel.location,
      profilePic: state.userModel.profilePic,
      userId: state.userModel.userId,
      identificacion: state.userModel.identificacion,
    );
    if (_name.text != null && _name.text.isNotEmpty) {
      model.displayName = _name.text;
    }
    if (_email.text != null && _email.text.isNotEmpty) {
      model.email = _email.text;
    }
    if (_bio.text != null && _bio.text.isNotEmpty) {
      model.bio = _bio.text;
    }
    if (_location.text != null && _location.text.isNotEmpty) {
      model.location = _location.text;
    }
    if (_identificacion.text != null && _identificacion.text.isNotEmpty) {
      model.identificacion = _identificacion.text;
    }
    if (dob != null) {
      model.dob = dob;
    }
    state.updateUserProfile(model, image: _image);
    Navigator.of(context).pop();
  }

  void uploadImage() {
    openImagePicker(context, (file) {
      setState(() {
        _image = file;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: customTitleText('Editar Perfil'),
        actions: <Widget>[
          InkWell(
            onTap: _submitButton,
            child: Center(
              child: Text(
                'Grabar',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: _body(),
      ),
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
