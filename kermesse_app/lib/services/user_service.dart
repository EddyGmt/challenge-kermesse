import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kermesse_app/models/requests/signupRequest.dart';
import 'package:kermesse_app/models/user.dart';

import '../config/app_config.dart';


class UserService extends ChangeNotifier{
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final apiAuthority = AppConfig.getApiAuthority();
  final isSecure = AppConfig.isSecure();


  //Création de kermesse
  Future<User?> createUser(Signuprequest newUser)async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/api/users')
          : Uri.http(apiAuthority, '/api/users');
      final token = await _storage.read(key: 'auth_token');
      if(token != null){
        final response = await http.post(
            url,
            headers: {
              "Content-Type":"application/json",
              "Auhtorization": "Bearer $token"
            },
            body: jsonEncode(newUser)
        );

        if(response.statusCode == 201){
          final responseData = jsonDecode(response.body);
          User user = User.fromJson(responseData);
          return user;
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
  Future<List<User>> getUsers()async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/api/users')
          : Uri.http(apiAuthority, '/api/users');
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

  Future<User?> getUserbyId(int id)async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/api/users/$id')
          : Uri.http(apiAuthority, '/api/users/$id');
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
          var responseData = jsonDecode(response.body);
          User user = User.fromJson(responseData);
          return user;
        }else{
          print("Erreur sur la récupération des jetons: ${response.statusCode}");
          return null;
        }
      }else{
        print("Erreur: token invalide");
        return null;
      }
    }catch(e){
      rethrow;
    }
  }
  //TODO update d'un user

  Future<bool> deleteUser(int id)async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/api/users/$id')
          : Uri.http(apiAuthority, '/api/users/$id');
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
}