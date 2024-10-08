import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../models/stand.dart';
import '../../models/user.dart';
import '../../services/stand_service.dart';
import '../../services/user_service.dart';

class StandDetailsScreen extends StatelessWidget {
  static const String routeName ='/stand-details';
  final int standId;

  const StandDetailsScreen({super.key, required this.standId});

  @override
  Widget build(BuildContext context) {
    final standService = Provider.of<StandService>(context);
    final userService = Provider.of<UserService>(context); // Ajouter le service UserService

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails du Stand"),
      ),
      body: FutureBuilder<Stand?>(
        future: standService.getStandById(standId),
        builder: (context, standSnapshot) {
          if (standSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (standSnapshot.hasError) {
            return Center(child: Text("Erreur : ${standSnapshot.error}"));
          } else if (standSnapshot.hasData) {
            final stand = standSnapshot.data!;
            // Faire une requête pour récupérer l'utilisateur via userID
            return FutureBuilder<User?>(
              future: userService.getUserbyId(stand.userID),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (userSnapshot.hasError) {
                  return Center(child: Text("Erreur : ${userSnapshot.error}"));
                } else if (userSnapshot.hasData) {
                  final user = userSnapshot.data!;
                  return buildStandAndUserDetails(stand, user);
                } else {
                  return const Center(child: Text("Aucun utilisateur trouvé"));
                }
              },
            );
          } else {
            return const Center(child: Text("Aucun stand trouvé"));
          }
        },
      ),
    );
  }

  Widget buildStandAndUserDetails(Stand stand, User user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(stand.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("Type : ${stand.type}"),
          const SizedBox(height: 10),
          Text("Description : ${stand.description}"),
          const SizedBox(height: 10),
          // Afficher les infos du créateur
          Text("Créateur du stand : ${user.firstname} ${user.lastname}"),

          if (stand.type == 'activité') ...[
            Text("Jetons requis : ${stand.jetonsRequis}"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                interactWithStand(stand.id);
              },
              child: const Text("Interagir avec le stand"),
            ),
          ],
          if (stand.type == 'alimentation') ...[
            const Text("Liste des produits :"),
            const SizedBox(height: 10),
            buildProductList(stand.stock ?? []),  // Assurez-vous que 'stock' contient bien les produits
          ],
        ],
      ),
    );
  }

  Widget buildProductList(List<Product> products) {
    if (products.isEmpty) {
      return const Text("Aucun produit disponible.");
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Image.network(product.picture),  // Affiche l'image du produit
            title: Text(product.name),
            subtitle: Text('Jetons requis : ${product.jetonsRequis}'),
            trailing: Text('Stock : ${product.nbProducts}'),
          ),
        );
      },
    );
  }

  void interactWithStand(int standId) {
    var standService = StandService().interactWithStand(standId);
  }
}
