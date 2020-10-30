import 'package:flutter/material.dart';

class NavigationModel {
  String title;
  IconData icon;

  NavigationModel({this.title, this.icon});
}

List<NavigationModel> navigationItems = [
  NavigationModel(title: "Mi Perfil", icon: Icons.person),
  NavigationModel(title: "Aplicaciones", icon: Icons.apps),
  NavigationModel(title: "Red Socialj", icon: Icons.group),
  NavigationModel(title: "Estadisticas", icon: Icons.account_balance),
  NavigationModel(title: "Backoffice", icon: Icons.offline_bolt),
  NavigationModel(title: "Autorizar App", icon: Icons.security),
  //NavigationModel(title: "Medios Digitales", icon: Icons.camera),

];