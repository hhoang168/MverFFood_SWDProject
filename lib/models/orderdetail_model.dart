import 'package:json_annotation/json_annotation.dart';

part 'orderdetail_model.g.dart';

@JsonSerializable()
class OrderDetailModel {
  String idProduct;
  String productImageLink;
  String productName;
  int quantity;
  double unitPrice;

  OrderDetailModel(
      {this.idProduct,
      this.productName,
      this.quantity,
      this.unitPrice,
      this.productImageLink});

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailModelToJson(this);
}
