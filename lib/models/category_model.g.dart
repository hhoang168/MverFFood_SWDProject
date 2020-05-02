// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) {
  return CategoryModel(
    idCategory: json['idCategory'] as String,
    createAt: json['createAt'] as String,
    description: json['description'] as String,
    name: json['name'] as String,
    updateAt: json['updateAt'] as String,
  );
}

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'idCategory': instance.idCategory,
      'createAt': instance.createAt,
      'description': instance.description,
      'name': instance.name,
      'updateAt': instance.updateAt,
    };
