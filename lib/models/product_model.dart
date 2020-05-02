import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  String idProduct;
  String createAt;
  String description;
  bool enabled;
  String idCategory;
  String idStore;
  String imageLink;
  String name;
  double price;
  String updateAt;

  ProductModel(
      {this.idProduct,
      this.createAt,
      this.description,
      this.enabled,
      this.idCategory,
      this.idStore,
      this.imageLink,
      this.name,
      this.price,
      this.updateAt});

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
