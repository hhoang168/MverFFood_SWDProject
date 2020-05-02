import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  String email;
  String password;
  String lastName;
  String firstName;
  String tokenGmail;

  LoginModel(
      {this.email,
      this.password,
      this.lastName,
      this.firstName,
      this.tokenGmail});

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
