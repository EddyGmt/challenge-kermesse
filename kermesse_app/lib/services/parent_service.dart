import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kermesse_app/models/requests/addChildrenRequest.dart';
import 'package:kermesse_app/models/requests/giveCoinsRequest.dart';

import '../config/app_config.dart';

class ParentService extends ChangeNotifier{
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final apiAuthority = AppConfig.getApiAuthority();
  final isSecure = AppConfig.isSecure();

  Future<bool> addChildren(AddChildrenRequest addedChildren)async{
     try{
       final url = isSecure
           ? Uri.https(apiAuthority, '/add-children')
           : Uri.http(apiAuthority, '/add-children');
       final token = await _storage.read(key: 'auth_token');
       if (token != null){
         final response = await http.post(
           url,
           headers: {
             "Content-Type":"application/json",
             "Authorization":"Bearer $token"
           },
           body: jsonEncode(addedChildren)
         );
         if(response.statusCode == 200){
           return true;
         }else{
           print("Erreur de requête: ${response.statusCode}");
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

  Future<bool> giveCoins(int id, GiveCoinsRequest givenCoins)async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/api/users/$id/give-coins')
          : Uri.http(apiAuthority, '/api/users/$id/give-coins');
      final token = await _storage.read(key: 'auth_token');
      if (token != null){
        final response = await http.post(
            url,
            headers: {
              "Content-Type":"application/json",
              "Authorization":"Bearer $token"
            },
            body: jsonEncode(givenCoins)
        );
        if(response.statusCode == 200){
          return true;
        }else{
          print("Erreur de requête: ${response.statusCode}");
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
}