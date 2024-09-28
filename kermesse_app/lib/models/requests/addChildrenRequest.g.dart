// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addChildrenRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddChildrenRequest _$AddChildrenRequestFromJson(Map<String, dynamic> json) =>
    AddChildrenRequest(
      (json['children_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$AddChildrenRequestToJson(AddChildrenRequest instance) =>
    <String, dynamic>{
      'children_ids': instance.childrenIds,
    };
