import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kermesse_app/models/requests/kermesseRequest.dart';
import '../config/app_config.dart';
import '../models/kermesse.dart';
import 'package:http/http.dart' as http;


class KermesseService extends ChangeNotifier{
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final apiAuthority = AppConfig.getApiAuthority();
  final isSecure = AppConfig.isSecure();


  //Création de kermesse
  Future<Kermesse?> createKermesse(KermesseRequest kermesse)async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/create-kermesse')
          : Uri.http(apiAuthority, '/create-kermesse');
      String? token = await _storage.read(key: 'auth_token');
      if(token != null){
        final response = await http.post(
            url,
            headers: {
            "Content-Type":"application/json",
            "Auhtorization": "Bearer $token"
          },
          body: jsonEncode(kermesse)
        );

        if(response.statusCode == 201){
          final responseData = jsonDecode(response.body);
          Kermesse newKermesse = Kermesse.fromJson(responseData);
          return newKermesse;
        }else{
          print("Erreur de requête: ${response.statusCode}");
          return null;
        }
      }else{
        print('Token invalide');
      }
    }catch(e){
      rethrow;
    }
  }

  //Récupérer toutes kermesses
  Future<List<Kermesse>> getKermesses()async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/kermesses')
          : Uri.http(apiAuthority, '/kermesses');
      String? token = await _storage.read(key: 'auth_token');
      if(token != null){
        final response = await http.get(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          }
        );

        if(response.statusCode == 200){
          var kermesseJson = jsonDecode(response.body)['kermesses'] as List;
          List<Kermesse> kermesses = kermesseJson.map(
              (element){
                return Kermesse.fromJson(element);
              }
          ).toList();
          return kermesses;
        }else{
          print("Erreur sur la récupération des jetons: ${response.statusCode}");
          return [];
        }
      }else{
        print("Erreur: token invalide");
        return [];
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Kermesse> getKermessebyId(int id)async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/kermesses/$id')
          : Uri.http(apiAuthority, '/kermesses/$id');
      String? token = await _storage.read(key: 'auth_token');
      if(token != null){
        final response = await http.get(
            url,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            }
        );
        if(response.statusCode == 200){
          var responseData = jsonDecode(response.body)['kermesse'];
          Kermesse kermesse = Kermesse.fromJson(responseData);
          return kermesse;
        }else{
          print("Erreur sur la récupération des jetons: ${response.statusCode}");
          throw Exception('Erreur de requête: ${response.statusCode}');
          //return null;
        }
      }else{
        print("Erreur: token invalide");
        throw Exception('Token non disponible');
       //return null;
      }
    }catch(e){
      rethrow;
    }
  }
  //TODO update de la kermesse

  Future<bool> deleteKermesse(int id)async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/kermesses/$id/delete')
          : Uri.http(apiAuthority, '/kermesses/$id/delete');
      final token = await _storage.read(key: 'auth_token');
      if(token != null){
        final reponse = await http.delete(
            url,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            }
        );
        if(reponse.statusCode == 200){
          return true;
        }else{
          print("Token non disponible");
          return false;
        }
      }else{
        print("Token non disponible");
        return false;
      }
    }catch(e){
      rethrow;
    }
  }

  //todo add stands
  //todo add participants
}