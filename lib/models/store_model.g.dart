// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreModel _$StoreModelFromJson(Map<String, dynamic> json) {
  return StoreModel(
    idStore: json['idStore'] as String,
    createAt: json['createAt'] as String,
    description: json['description'] as String,
    enabled: json['enabled'] as bool,
    endTime: json['endTime'] as String,
    imageUrl: json['imageUrl'] as String,
    name: json['name'] as String,
    idUser: json['idUser'] as String,
    startTime: json['startTime'] as String,
    categoryStoresByIdStore: (json['categoryStoresByIdStore'] as List)
        ?.map((e) => e == null
            ? null
            : CategoryModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    productsByIdStore: (json['productsByIdStore'] as List)
        ?.map((e) =>
            e == null ? null : ProductModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$StoreModelToJson(StoreModel instance) =>
    <String, dynamic>{
      'idStore': instance.idStore,
      'createAt': instance.createAt,
      'description': instance.description,
      'enabled': instance.enabled,
      'endTime': instance.endTime,
      'imageUrl': instance.imageUrl,
      'name': instance.name,
      'idUser': instance.idUser,
      'startTime': instance.startTime,
      'categoryStoresByIdStore': instance.categoryStoresByIdStore,
      'productsByIdStore': instance.productsByIdStore,
    };
