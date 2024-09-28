// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addUserRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddUserRequest _$AddUserRequestFromJson(Map<String, dynamic> json) =>
    AddUserRequest(
      json['type'] as String,
      (json['user_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$AddUserRequestToJson(AddUserRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'user_ids': instance.userIds,
    };
