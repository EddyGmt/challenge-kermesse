// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StandRequest _$StandRequestFromJson(Map<String, dynamic> json) => StandRequest(
      json['name'] as String,
      json['type'] as String,
      (json['jetons_requis'] as num).toInt(),
    );

Map<String, dynamic> _$StandRequestToJson(StandRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'jetons_requis': instance.jetonsRequis,
    };
