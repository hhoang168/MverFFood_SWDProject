import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:swd301/models/store_model.dart';

part 'store_api_service.chopper.dart';

@ChopperApi(baseUrl: '/stores/')
abstract class StoreApiService extends ChopperService {
  static StoreApiService create() {
    final client = ChopperClient(
        baseUrl: 'https://mffood.herokuapp.com/api',
        services: [_$StoreApiService()],
        converter: JsonToTypeConverter(
            {StoreModel: (jsonData) => StoreModel.fromJson(jsonData)}));
    return _$StoreApiService(client);
  }

  @Get()
  Future<Response<List<StoreModel>>> getStores(
      @Header('token') String headerValue, @Query('enabled') bool enabled);

  @Get(path: 'rating')
  Future<Response<List<StoreModel>>> getStoresByRating(
    @Header('token') String headerValue,
  );

  @Get(path: 'drink')
  Future<Response<List<StoreModel>>> getStoresHaveDrink(
      @Header('token') String headerValue);

  @Get(path: 'byCate/{categoryId}')
  Future<Response<List<StoreModel>>> getStoreByCategory(
      @Header('token') String headerValue, @Path() String categoryId);

  @Get(path: 'search')
  Future<Response<List<StoreModel>>> getStoreByName(
      @Header('token') String headerValue, @Query('name') String name);
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
