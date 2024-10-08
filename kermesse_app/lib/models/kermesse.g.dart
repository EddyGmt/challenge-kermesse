// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kermesse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kermesse _$KermesseFromJson(Map<String, dynamic> json) => Kermesse(
      (json['id'] as num?)?.toInt() ?? 0, // Gestion du null pour id
      json['name'] as String? ?? '', // Gestion du null pour name
      json['picture'] as String? ?? '', // Gestion du null pour picture
      (json['stands'] as List<dynamic>?)
          ?.map((e) => Stand.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [], // Gestion du null pour stands
      (json['organisateurs'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [], // Gestion du null pour organisateurs
      (json['participants'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [], // Gestion du null pour participants
      (json['user_id'] as num?)?.toInt() ?? 0, // Gestion du null pour user_id
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