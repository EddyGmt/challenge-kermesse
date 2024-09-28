import 'dart:core';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kermesse_app/models/requests/signupRequest.dart';
import 'dart:convert';
import '../models/user.dart';

class AuthService{
  //TODO revoir les routes afin de faire les appels api
  final String = "https://locahost:8080";
  final _storage = new FlutterSecureStorage();

  //Méthode de signup
  Future<User?> signup(Signuprequest newUser) async{
    try{
      final response = await http.post(
          Uri.parse('/signup'),
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
  Future<bool> login(email, password)async{
    try{
      final response = await http.post(
        Uri.parse("/login"),
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
      String? token = await _storage.read(key: 'auth_token');
      if (token != null){
        final response = await http.get(
            Uri.parse("/profile"),
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