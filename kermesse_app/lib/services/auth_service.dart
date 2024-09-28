import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kermesse_app/models/requests/signupRequest.dart';
import 'dart:convert';
import '../config/app_config.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier{
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final apiAuthority = AppConfig.getApiAuthority();
  final isSecure = AppConfig.isSecure();
  User? _currentUser;

  //Méthode de signup
  Future<User?> signup(Signuprequest newUser) async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/signup')
          : Uri.http(apiAuthority, '/signup');
      final response = await http.post(
          url,
          headers : {"Content-Type": "application/json"},
          body: jsonEncode(newUser.toJson())
      );
      if(response.statusCode == 201){
        return User.fromJson(jsonDecode(response.body));
      }else{
        print("Erreur lors de l'inscription: ${response.statusCode}");
        return null;
      }
    }catch(e){
      rethrow;
    }
  }

  //Login
  Future<bool> login(String email,String password)async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/login')
          : Uri.http(apiAuthority, '/login');
      final response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200){
        final responseData = jsonDecode(response.body.toString());
        final token = responseData["token"];
        await _storage.write(key: 'auth_token', value: token);
        return true;
      }else{
        print("Erreur lors de la connexion: ${response.statusCode}");
        return false;
      }
    }catch(e){
      rethrow;
    }
  }

  //Profile
  Future<User?> profile()async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/profile')
          : Uri.http(apiAuthority, '/profile');
      String? token = await _storage.read(key: 'auth_token');
      if (token != null){
        final response = await http.get(
            url,
            headers: {
              "Content-Type":"application/json",
              "Authorization":"Bearer $token"
            },
        );
        if(response.statusCode == 200){
          final responseData = jsonDecode(response.body);
          User user = User.fromJson(responseData);
          return user;
        }else{
          print("Erreur de requête: ${response.statusCode}");
          return null;
        }
      }else{
        print("Token non disponible");
        return null;
      }
    }catch(e){
      rethrow;
    }
  }

  //TODO logout
  //TODO update profile avec le model request en params
}