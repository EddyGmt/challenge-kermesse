// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      (json['id'] as num).toInt(),
      json['type'] as String,
      DateTime.parse(json['date_transaction'] as String),
      (json['price'] as num).toDouble(),
      (json['quantity'] as num).toInt(),
      (json['user_id'] as num).toInt(),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date_transaction': instance.dateTransaction.toIso8601String(),
      'price': instance.price,
      'quantity': instance.quantity,
      'user_id': instance.userID,
      'type': instance.type,
    };
