import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kermesse_app/models/product.dart';
import 'package:http/http.dart' as http;

class ProductService{
  final String = "https://locahost:8080";
  final _storage = new FlutterSecureStorage();
  //late Product product;

  //Créqtion de produit
  Future<Product?> createProduct(Product product)async{
    try{
      final token = await _storage.read(key: 'auth_token');
      if (token != null){
        final response = await http.post(
          Uri.parse("/create-product"),
          headers: {
            "Content-Type":"application/json",
            "Authorization":"Bearer $token"
          },
          body : jsonEncode(product.toJson()),
        );
        if(response.statusCode == 201){
          final responseData = jsonDecode(response.body);
          Product newProduct = Product.fromJson(responseData);
          return newProduct;
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

  //Récupérations des produits
  Future<Product?> getProducts() async{
    try{
      String? token = await _storage.read(key: 'auth_token');
      if(token != null){
        final response = await http.get(
            Uri.parse("/products"),
            headers : {
              "Content-Type" : "application/json",
              "Authorization": "Bearer $token"
            }
        );
        if(response.statusCode == 200){
          var responseData = jsonDecode(response.body);
          Product product = Product.fromJson(responseData);
          print(product);
          return product;
        }else{
          print("Erreur sur la récupération des jetons: ${response.statusCode}");
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

  //TODO update produits

  //Supprimer produit
  Future<bool> deleteProduct(int id)async{
    try{
      final token = await _storage.read(key: 'auth_token');
      if (token != null){
        final response = await http.delete(
          Uri.parse("/products/$id/delete"),
          headers: {
            "Content-Type":"application/json",
            "Authorization":"Bearer $token"
          },
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