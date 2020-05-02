import 'package:json_annotation/json_annotation.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel {
  String idAccount;
  int accountNumber;
  double balance;
  String createAt;
  String description;
  String idUser;

  AccountModel(
      {this.idAccount,
      this.accountNumber,
      this.balance,
      this.createAt,
      this.description,
      this.idUser});

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}
