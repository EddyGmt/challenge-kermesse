// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      (json['id'] as num).toInt(),
      json['firstname'] as String,
      json['lastname'] as String,
      json['email'] as String,
      json['password'] as String,
      json['picture'] as String,
      (json['role'] as num).toInt(),
      (json['jetons'] as num).toInt(),
      (json['parents'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['enfants'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['kermesses'] as List<dynamic>)
          .map((e) => Kermesse.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['stands'] as List<dynamic>)
          .map((e) => Stand.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['transactions'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['historique'] as List<dynamic>)
          .map((e) => History.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'password': instance.password,
      'picture': instance.picture,
      'role': instance.role,
      'jetons': instance.jetons,
      'parents': instance.parents,
      'enfants': instance.enfants,
      'kermesses': instance.kermesses,
      'stands': instance.stands,
      'transactions': instance.transactions,
      'historique': instance.historique,
    };
