import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentScreen extends StatelessWidget {
  final String clientSecret;

  PaymentScreen({required this.clientSecret});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Paiement")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await processPayment(clientSecret, context);
          },
          child: Text("Payer avec Stripe"),
        ),
      ),
    );
  }

  Future<void> processPayment(String clientSecret, BuildContext context) async {
    try {
      // Crée une méthode de paiement avec Stripe
      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Nom de ton entreprise',
        style: ThemeMode.system,
      ));

      // Affiche la feuille de paiement Stripe
      await Stripe.instance.presentPaymentSheet();

      // Si tout se passe bien, afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Paiement réussi !')),
      );
    } catch (e) {
      // Si une erreur survient, affiche un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }
}
