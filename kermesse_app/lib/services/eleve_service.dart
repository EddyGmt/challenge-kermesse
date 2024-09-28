import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kermesse_app/models/user.dart';

import '../config/app_config.dart';

class EleveService extends ChangeNotifier{
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final apiAuthority = AppConfig.getApiAuthority();
  final isSecure = AppConfig.isSecure();

  Future<List<User>> getEleve()async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/students')
          : Uri.http(apiAuthority, '/students');
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
          var userJson = jsonDecode(response.body) as List;
          List<User> users = userJson.map(
                  (element){
                return User.fromJson(element);
              }
          ).toList();
          return users;
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
}