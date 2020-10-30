import 'package:dribbbledanimation/Routes.dart';
import 'package:dribbbledanimation/Screens/Home/index.dart';
import 'package:dribbbledanimation/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'sidebar/sidebar_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:async';
import 'dart:io' show Platform;

void main() {
  new Routes();
//  new RoutesHome();
}

/*void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white
      ),
      home: SideBarLayout(),
    );
  }
}
*/
