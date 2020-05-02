import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:swd301/models/login_model.dart';
import 'package:swd301/models/user_model.dart';

part 'user_api_service.chopper.dart';

@ChopperApi(baseUrl: '/users/')
abstract class UserApiService extends ChopperService {
  static UserApiService create() {
    final client = ChopperClient(
        baseUrl: 'https://mffood.herokuapp.com/api',
        services: [_$UserApiService()],
        converter: JsonToTypeConverter(
            {UserModel: (jsonData) => UserModel.fromJson(jsonData)}));
    return _$UserApiService(client);
  }

  @Post (path: 'login')
  Future<Response<UserModel>> login(@Body() LoginModel loginModel, @Query('isGmail') bool isGmail);
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
