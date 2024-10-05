import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import '../models/jetons.dart';
import 'package:http/http.dart' as http;

class JetonsService extends ChangeNotifier {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final apiAuthority = AppConfig.getApiAuthority();
  final isSecure = AppConfig.isSecure();

  //Créqtion de jetons
  Future<Jetons?> createJetons(Jetons jetons) async {
    try {
      final url = isSecure
          ? Uri.https(apiAuthority, '/create-jeton')
          : Uri.http(apiAuthority, '/create-jeton');
      String? token = await _storage.read(key: 'auth_token');
      if (token != null) {
        final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(jetons.toJson()),
        );
        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          Jetons newJetons = Jetons.fromJson(responseData);
          return newJetons;
        } else {
          print("Erreur de requête: ${response.statusCode}");
          return null;
        }
      } else {
        print("Token non disponible");
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  //Récupérations des jetons
  Future<List<Jetons>> getJetons() async {
    try {
      final url = isSecure
          ? Uri.https(apiAuthority, '/jetons')
          : Uri.http(apiAuthority, '/jetons');
      String? token = await _storage.read(key: 'auth_token');
      print("Token récupéré : $token");
      if (token != null) {
        final response = await http.get(
          url,
          headers: {
            "Content-Type":"application/json",
            "Authorization":"Bearer $token"
          },
        );
        if (response.statusCode == 200) {
          var jetonsJson = jsonDecode(response.body)['jetons'] as List;
          List<Jetons> jetons = jetonsJson.map((element) {
            return Jetons.fromJson(element);
          }).toList();
          print("TOKEN GET JETONS $token");
          print(jetons);
          return jetons;
        } else {
          print(
              "Erreur sur la récupération des jetons: ${response.statusCode}");
          return [];
        }
      } else {
        print("Token non disponible");
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  //TODO update jetons

  //Supprimer jeton
  Future<bool> deleteJetons(int id) async {
    try {
      final url = isSecure
          ? Uri.https(apiAuthority, '/jetons/$id/delete')
          : Uri.http(apiAuthority, '/jetons/$id/delete');
      String? token = await _storage.read(key: 'auth_token');
      if (token != null) {
        final response = await http.delete(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
        );
        if (response.statusCode == 200) {
          return true;
        } else {
          print("Erreur lors de la suppression: ${response.statusCode}");
          return false;
        }
      } else {
        print("Token non disponible");
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
