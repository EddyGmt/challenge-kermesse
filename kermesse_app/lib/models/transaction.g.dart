// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      (json['id'] as num?)?.toInt() ?? 0, // Gère le 'null' pour 'id'
      json['type'] as String? ?? 'Unknown', // Gère le 'null' pour 'type'
      DateTime.parse(json['date_transaction'] as String? ?? DateTime.now().toString()), // Valeur par défaut pour 'date_transaction'
      (json['price'] as num?)?.toDouble() ?? 0.0, // Gère le 'null' pour 'price'
      (json['quantity'] as num?)?.toInt() ?? 1, // Gère le 'null' pour 'quantity'
      (json['user_id'] as num?)?.toInt() ?? 0, // Gère le 'null' pour 'user_id'
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
