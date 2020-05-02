// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responseorder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseOrderModel _$ResponseOrderModelFromJson(Map<String, dynamic> json) {
  return ResponseOrderModel(
    idOrders: json['idOrders'] as String,
    idStore: json['idStore'] as String,
    createAt: json['createAt'] as String,
    storeName: json['storeName'] as String,
    userName: json['userName'] as String,
    storeImageUrl: json['storeImageUrl'] as String,
    notes: json['notes'] as String,
    rating: json['rating'] as String,
    status: json['status'] as String,
    totalPrice: (json['totalPrice'] as num)?.toDouble(),
    orderDetail: (json['orderDetail'] as List)
        ?.map((e) => e == null
            ? null
            : OrderDetailModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ResponseOrderModelToJson(ResponseOrderModel instance) =>
    <String, dynamic>{
      'idOrders': instance.idOrders,
      'idStore': instance.idStore,
      'createAt': instance.createAt,
      'storeName': instance.storeName,
      'userName': instance.userName,
      'storeImageUrl': instance.storeImageUrl,
      'notes': instance.notes,
      'rating': instance.rating,
      'status': instance.status,
      'totalPrice': instance.totalPrice,
      'orderDetail': instance.orderDetail,
    };
