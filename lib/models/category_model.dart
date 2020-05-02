import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  String idCategory;
  String createAt;
  String description;
  String name;
  String updateAt;

  CategoryModel(
      {this.idCategory,
      this.createAt,
      this.description,
      this.name,
      this.updateAt});

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
