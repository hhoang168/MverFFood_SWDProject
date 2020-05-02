import 'package:swd301/models/orderdetail_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'requestorder_model.g.dart';

@JsonSerializable()
class RequestOrderModel {
  String idStore;
  String idUser;
  String notes;
  List<OrderDetailModel> orderDetailDTOList;

  RequestOrderModel(
      {this.idStore, this.idUser, this.notes, this.orderDetailDTOList});

  factory RequestOrderModel.fromJson(Map<String, dynamic> json) =>
      _$RequestOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestOrderModelToJson(this);
}
