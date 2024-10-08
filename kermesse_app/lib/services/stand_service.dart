import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kermesse_app/models/requests/standRequest.dart';
import 'package:kermesse_app/models/stand.dart';

import '../config/app_config.dart';


class StandService extends ChangeNotifier{
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final apiAuthority = AppConfig.getApiAuthority();
  final isSecure = AppConfig.isSecure();


  //Création de kermesse
  Future<Stand?> createStand(StandRequest newStand)async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/create-stand')
          : Uri.http(apiAuthority, '/create-stand');
      final token = await _storage.read(key: 'auth_token');
      if(token != null){
        final response = await http.post(
            url,
            headers: {
              "Content-Type":"application/json",
              "Auhtorization": "Bearer $token"
            },
            body: jsonEncode(newStand)
        );

        if(response.statusCode == 201){
          final responseData = jsonDecode(response.body);
          Stand stand = Stand.fromJson(responseData);
          return stand;
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

  //Récupérer tous les stands
  Future<List<Stand>> getStands()async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/stands')
          : Uri.http(apiAuthority, '/stands');
      final token = await _storage.read(key: 'auth_token');
      if(token != null){
        final response = await http.get(
            url,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            }
        );

        if(response.statusCode == 200){
          var standJson = jsonDecode(response.body) as List;
          List<Stand> stands = standJson.map(
                  (element){
                return Stand.fromJson(element);
              }
          ).toList();
          return stands;
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

  Future<Stand> getStandById(int id)async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/stands/$id')
          : Uri.http(apiAuthority, '/stands/$id');
      final token = await _storage.read(key: 'auth_token');
      if(token != null){
        final response = await http.get(
            url,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            }
        );
        if(response.statusCode == 200){
          var responseData = jsonDecode(response.body)['stand'];
          Stand stand = Stand.fromJson(responseData);
          return stand;
        }else{
          print("Erreur sur la récupération du stand: ${response.statusCode}");
          throw Exception('Erreur de requête: ${response.statusCode}');
          //return null;
        }
      }else{
        print("Erreur: token invalide");
        throw Exception('Token non valide');
        //return null;
      }
    }catch(e){
      rethrow;
    }
  }
  //TODO update d'un stand

  Future<bool> deleteStand(int id)async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/stands/$id/delete')
          : Uri.http(apiAuthority, '/stands/$id/delete');
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

  Future<bool> interactWithStand(int standId)async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/stands/$standId/interact')
          : Uri.http(apiAuthority, '/stands/$standId/interact');
      final token = await _storage.read(key: 'auth_token');
      if(token != null){
        final response = await http.post(
            url,
            headers: {
              "Content-Type":"application/json",
              "Authorization": "Bearer $token"
            },
        );

        if(response.statusCode == 200){
          return true;
        }else{
          print("Erreur de requête: ${response.statusCode}");
          return false;
        }
      }else{
        print('Token invalide');
        return false;
      }
    }catch(e){
      rethrow;
    }
  }
}