import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kermesse_app/services/kermesse_service.dart';
import 'package:provider/provider.dart';

import '../../models/kermesse.dart';
import '../../models/stand.dart';
import '../stand_details/standDetailsScreen.dart';

class KermesseDetailsScreen extends StatelessWidget {
  static const String routeName = "/kermesse-details";
  final int kermesseId;

  const KermesseDetailsScreen({super.key, required this.kermesseId});

  @override
  Widget build(BuildContext context) {
    KermesseService kermesseService = Provider.of<KermesseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails'),
      ),
      body: FutureBuilder<Kermesse?>(
        future: kermesseService.getKermessebyId(this.kermesseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("Erreur : ${snapshot}");
            return Center(child: Text("Erreur : ${snapshot}"));
          } else if (snapshot.hasData) {
            final kermesse = snapshot.data!;
            print("Stands: ${kermesse.stands}");
            return buildKermesseDetails(kermesse, context);
          } else {
            return const Center(child: Text("Aucune kermesse trouvée"));
          }
        },
      ),
    );
  }

  Widget buildKermesseDetails(Kermesse kermesse, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(kermesse.name,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          kermesse.stands != null && kermesse.stands!.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Liste des Stands",
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: kermesse.stands!.length,
                      itemBuilder: (context, index) {
                        final stand = kermesse.stands![index];
                        return buildStandCard(stand, context);
                      },
                    ),
                  ],
                )
              : const Text("Aucun stand disponible pour cette kermesse"),
        ],
      ),
    );
  }

  Widget buildStandCard(Stand stand, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(stand.name),
        subtitle: Text('Type : ${stand.type}'),
        onTap: () {
          Navigator.of(context).pushNamed(
            StandDetailsScreen.routeName,
            arguments: stand.id,
          );
        },
      ),
    );
  }
}
