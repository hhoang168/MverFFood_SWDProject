// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return ProductModel(
    idProduct: json['idProduct'] as String,
    createAt: json['createAt'] as String,
    description: json['description'] as String,
    enabled: json['enabled'] as bool,
    idCategory: json['idCategory'] as String,
    idStore: json['idStore'] as String,
    imageLink: json['imageLink'] as String,
    name: json['name'] as String,
    price: (json['price'] as num)?.toDouble(),
    updateAt: json['updateAt'] as String,
  );
}

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'idProduct': instance.idProduct,
      'createAt': instance.createAt,
      'description': instance.description,
      'enabled': instance.enabled,
      'idCategory': instance.idCategory,
      'idStore': instance.idStore,
      'imageLink': instance.imageLink,
      'name': instance.name,
      'price': instance.price,
      'updateAt': instance.updateAt,
    };
