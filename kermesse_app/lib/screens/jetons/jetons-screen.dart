import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:kermesse_app/models/jetons.dart';
import 'package:kermesse_app/models/requests/paymentRequest.dart';
import 'package:kermesse_app/services/payment_service.dart';
import 'package:provider/provider.dart';
import '../../services/jetons_service.dart';

class JetonsScreen extends StatelessWidget {
  static const String routeName = "/jetons";

  const JetonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupérer le service des jetons et le service de paiement
    JetonsService jetonsService = Provider.of<JetonsService>(context);
    Future<List<Jetons>> jetons = jetonsService.getJetons();

    return Scaffold(
      appBar: AppBar(title: const Text('Jetons')),
      body: FutureBuilder<List<Jetons>>(
          future: jetons,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              final jetonsData = snapshot.data!;
              return buildJetons(jetonsData, context);
            } else if (snapshot.hasError) {
              return Center(
                  child: Text("Erreur: ${snapshot.error}"));
            } else {
              return const Center(child: Text("Aucun jetons trouvés"));
            }
          }),
    );
  }

  // Fonction qui construit les cartes de jetons avec le bouton "Payer"
  Widget buildJetons(List<Jetons> jetons, BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Deux carrés par ligne
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1, // Carrés parfaits
      ),
      itemCount: jetons.length,
      itemBuilder: (context, index) {
        final jeton = jetons[index];

        return Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${jeton.nbJetons} Jetons',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '${jeton.price.toStringAsFixed(2)} €',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              // Bouton pour afficher le formulaire de paiement Stripe
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PaymentDialog(jeton: jeton);
                    },
                  );
                },
                child: Text('Payer avec Stripe'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Widget pour gérer le paiement via un formulaire Stripe
class PaymentDialog extends StatefulWidget {
  final Jetons jeton;

  const PaymentDialog({Key? key, required this.jeton}) : super(key: key);

  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  CardFieldInputDetails? _cardDetails;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Entrez vos détails de paiement"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Champ de saisie de la carte Stripe
          CardField(
            onCardChanged: (cardDetails) {
              setState(() {
                _cardDetails = cardDetails;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Numéro de carte',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Annuler"),
        ),
        ElevatedButton(
          onPressed: _cardDetails == null || !_cardDetails!.complete
              ? null
              : () async {
            try {
              await payForJetons(context, widget.jeton);
              Navigator.pop(context); // Fermer le dialogue après le succès
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Erreur lors du paiement: $e")),
              );
            }
          },
          child: const Text("Payer"),
        ),
      ],
    );
  }

  // Fonction pour lancer le paiement en utilisant PaymentService
  Future<void> payForJetons(BuildContext context, Jetons jeton) async {
    try {
      PaymentService paymentService =
      Provider.of<PaymentService>(context, listen: false);

      // Créer l'objet PaymentRequest
      PaymentRequest paymentRequest = PaymentRequest(
        "jetons",
        jeton.nbJetons,
        jeton.price,
      );

      // Obtenir le client_secret via PaymentService
      final clientSecret = await paymentService.payment(paymentRequest);

      // Traiter le paiement via Stripe
      await processPayment(clientSecret);
    } catch (e) {
      throw Exception("Erreur lors du traitement du paiement: $e");
    }
  }

  // Fonction pour traiter le paiement avec Stripe
  Future<void> processPayment(String clientSecret) async {
    try {
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(), // Supprimez le paramètre 'card'
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Paiement réussi !")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du paiement: $e")),
      );
    }
  }
}
