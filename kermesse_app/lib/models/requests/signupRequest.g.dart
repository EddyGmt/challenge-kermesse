// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signupRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Signuprequest _$SignuprequestFromJson(Map<String, dynamic> json) =>
    Signuprequest(
      json['firstname'] as String,
      json['lastname'] as String,
      json['email'] as String,
      json['password'] as String,
      json['picture'] as String,
      (json['role'] as num).toInt(),
    );

Map<String, dynamic> _$SignuprequestToJson(Signuprequest instance) =>
    <String, dynamic>{
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'password': instance.password,
      'picture': instance.picture,
      'role': instance.role,
    };
