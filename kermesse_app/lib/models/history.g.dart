// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

History _$HistoryFromJson(Map<String, dynamic> json) => History(
      (json['id'] as num).toInt(),
      DateTime.parse(json['date'] as String),
      json['stand_name'] as String,
      (json['user_id'] as num).toInt(),
    );

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'stand_name': instance.standName,
      'user_id': instance.userID,
    };
