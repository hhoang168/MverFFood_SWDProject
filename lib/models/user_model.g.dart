// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    idUser: json['idUser'] as String,
    tokenJWT: json['tokenJWT'] as String,
    userRoleDTO:
        (json['userRoleDTO'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'idUser': instance.idUser,
      'tokenJWT': instance.tokenJWT,
      'userRoleDTO': instance.userRoleDTO,
    };
