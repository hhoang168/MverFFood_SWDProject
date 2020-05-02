import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String idUser;
  String tokenJWT;
  List<String> userRoleDTO;

  UserModel({this.idUser, this.tokenJWT, this.userRoleDTO});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}