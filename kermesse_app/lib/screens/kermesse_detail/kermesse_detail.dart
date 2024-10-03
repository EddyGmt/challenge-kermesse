import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kermesse_app/services/kermesse_service.dart';
import 'package:provider/provider.dart';

import '../../models/kermesse.dart';

class KermesseDetailsScreen extends StatelessWidget{
  static const String routeName = "/kermesse-details";
  final int kermesseId;
  const KermesseDetailsScreen({super.key, required this.kermesseId});


  @override
  Widget build(BuildContext context) {
    KermesseService kermesseService = Provider.of<KermesseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la Kermesse'),
      ),
      body: FutureBuilder<Kermesse?>(
        future: kermesseService.getKermessebyId(this.kermesseId),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if(snapshot.hasError){
            return const Center(child: Text("Erreur de chargement des détails"));
          }else if(snapshot.hasData){
            final kermesse = snapshot.data!;
            return buildKermesseDetails(kermesse);
          }else{
            return const Center(child: Text("Aucune kermesse trouvée"));
          }
        },
      ),
    );
  }
  Widget buildKermesseDetails(Kermesse kermesse){
    return Container ();
  }
}