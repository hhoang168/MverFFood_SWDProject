// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orderdetail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailModel _$OrderDetailModelFromJson(Map<String, dynamic> json) {
  return OrderDetailModel(
    idProduct: json['idProduct'] as String,
    productName: json['productName'] as String,
    quantity: json['quantity'] as int,
    unitPrice: (json['unitPrice'] as num)?.toDouble(),
    productImageLink: json['productImageLink'] as String,
  );
}

Map<String, dynamic> _$OrderDetailModelToJson(OrderDetailModel instance) =>
    <String, dynamic>{
      'idProduct': instance.idProduct,
      'productImageLink': instance.productImageLink,
      'productName': instance.productName,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
    };
