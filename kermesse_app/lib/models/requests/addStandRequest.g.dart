// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addStandRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddStandRequest _$AddStandRequestFromJson(Map<String, dynamic> json) =>
    AddStandRequest(
      (json['stand_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$AddStandRequestToJson(AddStandRequest instance) =>
    <String, dynamic>{
      'stand_ids': instance.standIds,
    };
