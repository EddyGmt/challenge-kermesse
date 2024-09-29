import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kermesse_app/widgets/app_drawer.dart';

class Homescreen extends StatelessWidget{
  static const String routeName = "/home";
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text("Bienvenue sur l'accueil de KERMESSE ESGI. Le meilleur arrive"),
      ),
    );
  }
}