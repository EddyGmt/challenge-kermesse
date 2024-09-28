import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/jetons.dart';
import 'package:http/http.dart' as http;

class JetonsService{
  final String = "https://locahost:8080";
  final _storage = new FlutterSecureStorage();
  late Jetons jetons;

  //Créqtion de jetons
  Future<Jetons?> createJetons(Jetons jetons)async{
    try{
      final token = await _storage.read(key: 'auth_token');
      if (token != null){
        final response = await http.post(
          Uri.parse("/create-jeton"),
          headers: {
            "Content-Type":"application/json",
            "Authorization":"Bearer $token"
          },
          body : jsonEncode(jetons.toJson()),
        );
        if(response.statusCode == 201){
          final responseData = jsonDecode(response.body);
          Jetons newJetons = Jetons.fromJson(responseData);
          return newJetons;
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

  //Récupérations des jetons
  Future<Jetons?> getJetons() async{
    try{
      final response = await http.get(
        Uri.parse("/jetons"),
        headers : {"Content-Type" : "application/json"}
      );
      if(response.statusCode == 200){
        var responseData = jsonDecode(response.body);
        Jetons jetons = Jetons.fromJson(responseData);
        print(jetons);
        return jetons;
      }else{
        print("Erreur sur la récupération des jetons: ${response.statusCode}");
        return null;
      }
    }catch(e){
      rethrow;
    }
  }

  //TODO update jetons

  //Supprimer jeton
  Future<bool> deleteJetons(int id)async{
    try{
      final token = await _storage.read(key: 'auth_token');
      if (token != null){
        final response = await http.delete(
          Uri.parse("/jetons/$id/delete"),
          headers: {
            "Content-Type":"application/json",
            "Authorization":"Bearer $token"
          },
          //body : jsonEncode(jetons.toJson()),
        );
        if(response.statusCode == 200){
          return true;
        }else{
          print("Erreur lors de la suppression: ${response.statusCode}");
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
