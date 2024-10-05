import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kermesse_app/models/requests/paymentRequest.dart';

import '../config/app_config.dart';

class PaymentService extends ChangeNotifier{
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final apiAuthority = AppConfig.getApiAuthority();
  final isSecure = AppConfig.isSecure();

  Future<String>payment(PaymentRequest paymentRequest)async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/payment')
          : Uri.http(apiAuthority, '/payment');
      final token = await _storage.read(key: 'auth_token');
      if (token != null){
        final response = await http.post(
            url,
            headers: {
              "Content-Type":"application/json",
              "Authorization":"Bearer $token"
            },
            body: jsonEncode(paymentRequest)
        );
        if(response.statusCode == 200){
          final jsonResponse = jsonDecode(response.body);
          return jsonResponse['paymentIntent']['client_secret'];
        }else{
          print("Erreur de requête: ${response.statusCode}");
          throw Exception('Erreur lors de la création du paiement');
        }
      }else{
        //print("Token non disponible");
        throw Exception('Token non disponible');
      }
    }catch(e){
      rethrow;
    }
  }
}