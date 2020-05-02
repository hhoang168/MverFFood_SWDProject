import 'package:swd301/models/category_model.dart';
import 'package:swd301/models/product_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'store_model.g.dart';

@JsonSerializable()
class StoreModel {
  String idStore;
  String createAt;
  String description;
  bool enabled;
  String endTime;
  String imageUrl;
  String name;
  String idUser;
  String startTime;
  List<CategoryModel> categoryStoresByIdStore;
  List<ProductModel> productsByIdStore;

  StoreModel({this.idStore,
    this.createAt,
    this.description,
    this.enabled,
    this.endTime,
    this.imageUrl,
    this.name,
    this.idUser,
    this.startTime,
    this.categoryStoresByIdStore,
    this.productsByIdStore});

  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoreModelToJson(this);
}