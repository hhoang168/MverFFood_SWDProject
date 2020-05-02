import 'package:chopper/chopper.dart';
import 'package:swd301/models/category_model.dart';
import 'package:swd301/models/responseorder_model.dart';
import 'package:swd301/models/requestorder_model.dart';
import 'package:swd301/models/store_model.dart';
import 'dart:convert';

part 'category_api_service.chopper.dart';

@ChopperApi(baseUrl: '/categories/')
abstract class CategoryApiService extends ChopperService {
  static CategoryApiService create() {
    final client = ChopperClient(
      baseUrl: 'https://mffood.herokuapp.com/api',
      services: [_$CategoryApiService()],
      converter: JsonToTypeConverter({
        CategoryModel: (jsonData) => CategoryModel.fromJson(jsonData)
      }),
    );
    return _$CategoryApiService(client);
  }

  @Get()
  Future<Response<List<CategoryModel>>> getCategories(@Header('token') String headerValue,);
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
