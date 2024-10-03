// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stand _$StandFromJson(Map<String, dynamic> json) => Stand(
      (json['id'] as num).toInt(),
      json['name'] as String,
      json['type'] as String,
      (json['stock'] as List<dynamic>?)?.map((e) => Product.fromJson(e)).toList() ?? [],
      json['pts_donnees'] as int? ?? 0,
      json['conso'] as int? ?? 0,
      json['jetonsRequis'] as int? ?? 0,
      (json['kermesses'] as List<dynamic>?)?.map((e) => Kermesse.fromJson(e)).toList() ?? [],
      (json['user_id'] as num).toInt(),
    );

Map<String, dynamic> _$StandToJson(Stand instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'stock': instance.stock,
      'pts_donnees': instance.pts_donnees,
      'conso': instance.conso,
      'jetons_requis': instance.jetonsRequis,
      'kermesses': instance.kermesses,
      'user_id': instance.userID,
    };
