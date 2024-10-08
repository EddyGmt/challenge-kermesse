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
            Navigator.of(context).pushNamed(
              KermesseDetailsScreen.routeName,
              arguments: kermesse.id,
            );
          },
          child: Card(
            margin: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              height: 120,
              child: Row(
                children: [
                  // Image de la kermesse
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      kermesse.picture,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 100);
                      },
                    ),
                  ),
                  const SizedBox(width: 16), // Espacement entre l'image et le texte
                  // Nom de la kermesse et nombre de stands
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Nom de la kermesse
                        Text(
                          kermesse.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8), // Espacement
                        // Nombre de stands (facultatif)
                        if (kermesse.stands != null)
                          Text(
                            '${kermesse.stands!.length} stands',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
