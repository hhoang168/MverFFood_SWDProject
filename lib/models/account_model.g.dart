// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) {
  return AccountModel(
    idAccount: json['idAccount'] as String,
    accountNumber: json['accountNumber'] as int,
    balance: (json['balance'] as num)?.toDouble(),
    createAt: json['createAt'] as String,
    description: json['description'] as String,
    idUser: json['idUser'] as String,
  );
}

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'idAccount': instance.idAccount,
      'accountNumber': instance.accountNumber,
      'balance': instance.balance,
      'createAt': instance.createAt,
      'description': instance.description,
      'idUser': instance.idUser,
    };
