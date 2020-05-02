// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requestorder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestOrderModel _$RequestOrderModelFromJson(Map<String, dynamic> json) {
  return RequestOrderModel(
    idStore: json['idStore'] as String,
    idUser: json['idUser'] as String,
    notes: json['notes'] as String,
    orderDetailDTOList: (json['orderDetailDTOList'] as List)
        ?.map((e) => e == null
            ? null
            : OrderDetailModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$RequestOrderModelToJson(RequestOrderModel instance) =>
    <String, dynamic>{
      'idStore': instance.idStore,
      'idUser': instance.idUser,
      'notes': instance.notes,
      'orderDetailDTOList': instance.orderDetailDTOList,
    };
