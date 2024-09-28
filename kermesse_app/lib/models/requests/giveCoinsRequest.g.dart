// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'giveCoinsRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiveCoinsRequest _$GiveCoinsRequestFromJson(Map<String, dynamic> json) =>
    GiveCoinsRequest(
      (json['nb_jetons'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$GiveCoinsRequestToJson(GiveCoinsRequest instance) =>
    <String, dynamic>{
      'nb_jetons': instance.nbJetons,
    };
