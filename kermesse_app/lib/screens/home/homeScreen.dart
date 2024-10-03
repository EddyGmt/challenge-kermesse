import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kermesse_app/screens/kermesse_detail/kermesse_detail.dart';
import 'package:kermesse_app/services/kermesse_service.dart';
import 'package:kermesse_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../../models/kermesse.dart';

class Homescreen extends StatelessWidget {
  static const String routeName = "/home";

  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    KermesseService kermesseService = Provider.of<KermesseService>(context);
    Future<List<Kermesse>> kermesses = kermesseService.getKermesses();

    return Scaffold(
      appBar: AppBar(title: const Text("Accueil")),
      drawer: const AppDrawer(),
      body: Center(
        child: FutureBuilder<List<Kermesse>>(
          future: kermesses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final kermesseData = snapshot.data!;
              return buildKermesses(kermesseData);
            } else if (snapshot.hasError) {
              print("Erreur: ${snapshot.error}");
              return const Text("Erreur lors de la récuparation des kermesses");
            } else {
              return const Text(
                  "Vous n'êtes dans aucune kermesse pour le moment");
            }
          },
        ),
      ),
    );
  }

  Widget buildKermesses(List<Kermesse> kermesses) {
    return ListView.builder(
      itemCount: kermesses.length,
      itemBuilder: (context, index) {
        final kermesse = kermesses[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(KermesseDetailsScreen.routeName,
                arguments: kermesse.id);
          },
          child: Container(
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(9.0),
            height: 100,
            child: Row(
              children: [
                Expanded(flex: 1, child: Text((kermesse.name).toString())),
                //xpanded(flex:1, child: Text((jeton.price).toString()))
              ],
            ),
          ),
        );
      },
    );
  }
}
