// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      (json['id'] as num).toInt(),
      json['name'] as String,
      json['picture'] as String,
      json['type'] as String,
      (json['jetons_requis'] as num).toInt(),
      (json['nb_products'] as num).toInt(),
      (json['stand_id'] as num).toInt(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'picture': instance.picture,
      'type': instance.type,
      'jetons_requis': instance.jetonsRequis,
      'nb_products': instance.nbProducts,
      'stand_id': instance.standID,
    };
