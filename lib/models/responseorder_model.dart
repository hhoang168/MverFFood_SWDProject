import 'package:swd301/models/orderdetail_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'responseorder_model.g.dart';

@JsonSerializable()
class ResponseOrderModel {
  String idOrders;
  String idStore;
  String createAt;
  String storeName;
  String userName;
  String storeImageUrl;
  String notes;
  String rating;
  String status;
  double totalPrice;
  List<OrderDetailModel> orderDetail;

  ResponseOrderModel(
      {this.idOrders,
      this.idStore,
      this.createAt,
      this.storeName,
      this.userName,
      this.storeImageUrl,
      this.notes,
      this.rating,
      this.status,
      this.totalPrice,
      this.orderDetail});

  factory ResponseOrderModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseOrderModelToJson(this);
}
