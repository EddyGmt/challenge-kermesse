import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kermesse_app/models/product.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';

class ProductService extends ChangeNotifier{
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final apiAuthority = AppConfig.getApiAuthority();
  final isSecure = AppConfig.isSecure();

  //Créqtion de produit
  Future<Product?> createProduct(Product product)async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/create-product')
          : Uri.http(apiAuthority, '/create-product');
      final token = await _storage.read(key: 'auth_token');
      if (token != null){
        final response = await http.post(
          url,
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

  Future<List<Product>> getProducts() async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/products')
          : Uri.http(apiAuthority, '/products');
      final token = await _storage.read(key: 'auth_token');
      if(token != null){
        final response = await http.get(
            url,
            headers : {
              "Content-Type" : "application/json",
              "Authorization": "Bearer $token"
            }
        );
        if(response.statusCode == 200){
          var productJson = jsonDecode(response.body) as List;
          List<Product> products = productJson.map(
              (element){
                return Product.fromJson(element);
              }
          ).toList();
          print(products);
          return products;
        }else{
          print("Erreur sur la récupération des jetons: ${response.statusCode}");
          return [];
        }
      }else{
        print("Token non disponible");
        return [];
      }
    }catch(e){
      rethrow;
    }
  }

  //Récupérations d'un produit
  Future<Product?> getProductbyId(int id) async{
    try{
      final url = isSecure
          ? Uri.https(apiAuthority, '/products/$id')
          : Uri.http(apiAuthority, '/products/$id');
      String? token = await _storage.read(key: 'auth_token');
      if(token != null){
        final response = await http.get(
            url,
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
      final url = isSecure
          ? Uri.https(apiAuthority, '/products/$id/delete')
          : Uri.http(apiAuthority, '/products/$id/delete');
      final token = await _storage.read(key: 'auth_token');
      if (token != null){
        final response = await http.delete(
         url,
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