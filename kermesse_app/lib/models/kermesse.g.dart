// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kermesse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kermesse _$KermesseFromJson(Map<String, dynamic> json) => Kermesse(
      (json['id'] as num).toInt(),
      json['name'] as String,
      json['picture'] as String,
      (json['stands'] as List<dynamic>?)?.map((e) => Stand.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      (json['organisateurs'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      (json['participants'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      (json['user_id'] as num).toInt(),
    );

Map<String, dynamic> _$KermesseToJson(Kermesse instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'picture': instance.picture,
      'stands': instance.stands,
      'organisateurs': instance.organisateurs,
      'participants': instance.participants,
      'user_id': instance.userID,
    };
