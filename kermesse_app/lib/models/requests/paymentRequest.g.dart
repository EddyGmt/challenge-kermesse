// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paymentRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) =>
    PaymentRequest(
      json['type'] as String,
      (json['quantity'] as num).toInt(),
      (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$PaymentRequestToJson(PaymentRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'quantity': instance.quantity,
      'price': instance.price,
    };
