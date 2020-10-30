import 'package:dribbbledanimation/Screens/Home/inicio.dart';
import 'package:dribbbledanimation/Screens/Login/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './Screens/social/user_feed_page.dart';
import './Screens/social/afiliados.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dribbbledanimation/Screens/Home/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:dribbbledanimation/Components/Auth.dart';

class HomeSreenT extends StatefulWidget {
  final FirebaseUser user;
  HomeSreenT(this.user) {
    print("HomeSreenT");
  }
  @override
  _HomeSreenTState createState() => _HomeSreenTState(user);
}

class _HomeSreenTState extends State<HomeSreenT> {
  var selectedPageIndex = 0;
  final FirebaseUser user;
  int _tipo = 0;

  var menuDerecho = [
    {"imagen": "campania.jpeg", "label": "CAMPAÑA"},
    {"imagen": "crc.jpeg", "label": "CRC"},
    {"imagen": "fis.jpeg", "label": "FIS"},
    {"imagen": "afiliaciones.jpeg", "label": "AFILIACIONES"},
    {"imagen": "encuestas.jpeg", "label": "ENCUESTAS"},
    {"imagen": "censo.jpeg", "label": "CENSO"},
    {"imagen": "utilitarios.jpeg", "label": "UTILITARIOS"},
    {"imagen": "centroElectoral.jpeg", "label": "CENTRO ELECTORAL"},
  ];
  _HomeSreenTState(this.user);

  _getImageProfile() {
    if (user.providerData != null) {
      for (int i = 0; i < user.providerData.length; i++) {
        if (user.providerData.elementAt(i) != null &&
            user.providerData.elementAt(i).photoUrl != null) {
          return user.providerData.elementAt(i).photoUrl;
        }
      }
    }
    return null;
    //https://lh3.googleusercontent.com/a-/AOh14Gj2ty4Rjudt-rR0-7w86YIWFIl8HYmGfY5J4hzJ=s96-c
  }

  _getUserName() {
    print(user.email);
    print(user.providerData.elementAt(0).email);
    print(user.providerData.elementAt(1).email);
    print(user.providerData.elementAt(1).displayName);
    print(user.providerData.elementAt(1).phoneNumber);
    print(user.providerData.elementAt(1).photoUrl);

    if (user.providerData != null) {
      for (int i = 0; i < user.providerData.length; i++) {
        if (user.providerData.elementAt(i) != null &&
            user.providerData.elementAt(i).displayName != null) {
          return user.providerData.elementAt(i).displayName;
        }
      }
      for (int i = 0; i < user.providerData.length; i++) {
        if (user.providerData.elementAt(i) != null &&
            user.providerData.elementAt(i).email != null) {
          return user.providerData.elementAt(i).email;
        }
      }
    }
    if (user.phoneNumber != null) {
      return user.phoneNumber;
    }
    if (user.email != null) {
      return user.email;
    }
    if (user.displayName != null) {
      return user.displayName;
    }
  }

  _getPantall() {
    return new UserFeedPage(_getUserName(), _getImageProfile(), _tipo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.blue), //add this line here
          title: Text(
            "AppRC",
            style: TextStyle(color: Colors.black, fontFamily: 'Colibri'),
          ),
          /*actions: <Widget>[
          IconButton(
            icon: Image.asset(
              'assets/iconos/G1.jpeg',
              //fit: BoxFit.contain,
              width: 100,
              height: 100,
            ),
            tooltip: 'Show Snackbar',
            onPressed: () {
              //scaffoldKey.currentState.showSnackBar(snackBar);
            },
          ),
        ],*/
          backgroundColor: Colors.white,
          //leading: build(color: Colors.red),
        ),
        body: _getPantall(),
        drawer: Drawer(
          child: ListView(children: <Widget>[
            Container(
              height: 100,
              child: DrawerHeader(
                  child: Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Material(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      elevation: 8,
                      child: Padding(
                        padding: EdgeInsets.all(2),
                        child: _getImageProfile() != false
                            ? Image.network(_getImageProfile(),
                                width: 60, height: 60)
                            : Image.asset(
                                'assets/iconos/G1.jpeg',
                                width: 60,
                                height: 60,
                              ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(_getUserName(),
                                  style: TextStyle(
                                      fontSize: 15, fontFamily: 'Colibri')),
                              Text(
                                  DateFormat()
                                      .format(new DateTime.now().toLocal()),
                                  style: TextStyle(
                                      fontSize: 10, fontFamily: 'Colibri'))
                            ]))
                  ],
                ),
              )),
            ),
            Menu(
              "assets/iconos/E.jpeg",
              "Inicio",
              () => {},
              null,
            ),
            Divider(
              height: 15,
              thickness: 2.5,
              color: Colors.grey.withOpacity(0.3),
              indent: 32,
              endIndent: 32,
            ),
            Menu(
              "assets/iconos/F.jpeg",
              "Autorizar Miembro",
              () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
              null,
            ),
            Menu(
              "assets/iconos/B.jpeg",
              "Retirar Miembro",
              () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
              null,
            ),
            Menu(
              "assets/iconos/B.jpeg",
              "Bloquear Miembro",
              () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
              null,
            ),
            Menu(
              "assets/iconos/I.jpeg",
              "Registro de Actidad",
              () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
              null,
            ),
            Menu(
              "assets/iconos/D.jpeg",
              "Editar Perfil",
              () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
              null,
            ),
            Divider(
              height: 15,
              thickness: 2.5,
              color: Colors.grey.withOpacity(0.3),
              indent: 32,
              endIndent: 32,
            ),
            Menu(
              "assets/iconos/H.jpeg",
              "Configuracion",
              () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
              null,
            ),
            Menu(
              "assets/iconos/H.jpeg",
              "Cerrar sesión",
              () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Auth().signOut();

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              Icons.settings_power,
            ),
            Divider(
              height: AppBar().preferredSize.height,
              thickness: 2.5,
              color: Colors.grey.withOpacity(0.3),
              indent: 32,
              endIndent: 32,
            ),
            Container(
                height: AppBar().preferredSize.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("Powered By Kubic.ec",
                        style: TextStyle(fontSize: 18, fontFamily: 'Colibri'))
                  ],
                )),
          ]),
        ),
        endDrawer: Drawer(
          /*Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width -
              (MediaQuery.of(context).size.width * 20) / 100,
          height: MediaQuery.of(context).size.height -
              (MediaQuery.of(context).size.height * 50) / 100,
          //color: Colors.white,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                //bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(40)),
            /*boxShadow: [
              BoxShadow(
                color: Colors.white,
                /*.withOpacity(0.8),*/
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],*/
          ),*/
          child: GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 3,
            //padding: EdgeInsets.all(20),
            // Generate 100 widgets that display their index in the List.
            children: List.generate(menuDerecho.length, (index) {
              return Center(
                  child: InkWell(
                      splashColor: Colors.greenAccent,
                      onTap: () => setState(() {
                            _tipo = index;
                          }),
                      child: Column(children: [
                        Image.asset(
                          "assets/iconos/menuDerecho/${menuDerecho[index]['imagen']}",
                          height: 80,
                          width: 80,
                        ),
                        Text(menuDerecho[index]['label'],
                            style:
                                TextStyle(fontSize: 10, fontFamily: 'Colibri')),
                      ])));
            }),
          ),
        ),
        //),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              title: Text(""),
              icon: Icon(
                FontAwesomeIcons.home,
                color: selectedPageIndex == 0 ? Colors.blue : Colors.blueGrey,
              ),
            ),
            BottomNavigationBarItem(
              title: Text(""),
              icon: Icon(
                FontAwesomeIcons.search,
                color: selectedPageIndex == 1 ? Colors.blue : Colors.blueGrey,
              ),
            ),
            BottomNavigationBarItem(
                title: Text(""),
                icon: Icon(
                  FontAwesomeIcons.bell,
                  color: selectedPageIndex == 2 ? Colors.blue : Colors.blueGrey,
                )),
            BottomNavigationBarItem(
              title: Text(""),
              icon: Icon(
                FontAwesomeIcons.envelope,
                color: selectedPageIndex == 3 ? Colors.blue : Colors.blueGrey,
              ),
            ),
          ],
          onTap: (index) {
            print(index);
            //pickImageFromGallery(ImageSource.gallery);
          },
          currentIndex: selectedPageIndex,
          //  ),
        ));
  }
}

class Menu extends StatelessWidget {
  IconData icon;
  String nombre;
  String menu;
  Function onTap;
  Menu(this.nombre, this.menu, this.onTap, this.icon);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: InkWell(
        splashColor: Colors.greenAccent,
        onTap: onTap,
        child: Container(
          //  height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children: <Widget>[
                icon != null
                    ? Icon(icon)
                    : Image.asset(
                        nombre,
                        height: 30,
                        width: 30,
                      ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(menu,
                      style: TextStyle(fontSize: 18, fontFamily: 'Colibri')),
                ),
              ]),
              //  Icon(Icons.arrow_right)
            ],
          ),
        ),
      ),
    );
  }
}
