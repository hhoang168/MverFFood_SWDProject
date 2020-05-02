import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:swd301/models/requestorder_model.dart';
import 'package:swd301/models/responseorder_model.dart';

part 'order_api_service.chopper.dart';

@ChopperApi(baseUrl: '/orders/')
abstract class OrderApiService extends ChopperService {
  static OrderApiService create() {
    final client = ChopperClient(
      baseUrl: 'https://mffood.herokuapp.com/api',
      services: [_$OrderApiService()],
      converter: JsonToTypeConverter({
        ResponseOrderModel: (jsonData) => ResponseOrderModel.fromJson(jsonData)
      }),
    );
    return _$OrderApiService(client);
  }

  @Post()
  Future<Response<ResponseOrderModel>> createOrder(
      @Header('token') String headerValue,@Body() RequestOrderModel orderModel);

  @Get(path: 'byUser/{idUser}')
  Future<Response<List<ResponseOrderModel>>> getOrder(@Header('token') String headerValue,@Path() String idUser);
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
