// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$OrderApiService extends OrderApiService {
  _$OrderApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = OrderApiService;

  Future<Response<ResponseOrderModel>> createOrder(
      String headerValue, RequestOrderModel orderModel) {
    final $url = '/orders/';
    final $headers = {'token': headerValue};
    final $body = orderModel;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<ResponseOrderModel, ResponseOrderModel>($request);
  }

  Future<Response<List<ResponseOrderModel>>> getOrder(
      String headerValue, String idUser) {
    final $url = '/orders/byUser/$idUser';
    final $headers = {'token': headerValue};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<List<ResponseOrderModel>, ResponseOrderModel>($request);
  }
}
