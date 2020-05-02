import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:swd301/models/account_model.dart';

part 'account_api_service.chopper.dart';

@ChopperApi(baseUrl: '/accounts/')
abstract class AccountApiService extends ChopperService {
  static AccountApiService create() {
    final client = ChopperClient(
        baseUrl: 'https://mffood.herokuapp.com/api',
        services: [_$AccountApiService()],
        converter: JsonToTypeConverter(
            {AccountModel: (jsonData) => AccountModel.fromJson(jsonData)}));
    return _$AccountApiService(client);
  }

  @Get (path: '{userID}')
  Future<Response<List<AccountModel>>> getAccountByUserID(@Header('token') String headerValue, @Path() String userID);
}

class JsonToTypeConverter extends JsonConverter {
  final Map<Type, Function> typeToJsonFactoryMap;

  JsonToTypeConverter(this.typeToJsonFactoryMap);

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {
    return response.replace(
      body: fromJsonData<BodyType, InnerType>(
          response.body, typeToJsonFactoryMap[InnerType]),
    );
  }

  T fromJsonData<T, InnerType>(String jsonData, Function jsonParser) {
    var jsonMap = json.decode(jsonData);

    if (jsonMap is List) {
      return jsonMap
          .map((item) => jsonParser(item as Map<String, dynamic>) as InnerType)
          .toList() as T;
    }

    return jsonParser(jsonMap);
  }
}
