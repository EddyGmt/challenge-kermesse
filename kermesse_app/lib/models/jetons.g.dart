// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jetons.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Jetons _$JetonsFromJson(Map<String, dynamic> json) => Jetons(
      (json['id'] as num).toInt(),
      (json['nb_jetons'] as num).toInt(),
      (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$JetonsToJson(Jetons instance) => <String, dynamic>{
      'id': instance.id,
      'nb_jetons': instance.nbJetons,
      'price': instance.price,
    };
