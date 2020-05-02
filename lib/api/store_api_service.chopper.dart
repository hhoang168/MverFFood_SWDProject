// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$StoreApiService extends StoreApiService {
  _$StoreApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = StoreApiService;

  Future<Response<List<StoreModel>>> getStores(
      String headerValue, bool enabled) {
    final $url = '/stores/';
    final Map<String, dynamic> $params = {'enabled': enabled};
    final $headers = {'token': headerValue};
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<List<StoreModel>, StoreModel>($request);
  }

  Future<Response<List<StoreModel>>> getStoresByRating(String headerValue) {
    final $url = '/stores/rating';
    final $headers = {'token': headerValue};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<List<StoreModel>, StoreModel>($request);
  }

  Future<Response<List<StoreModel>>> getStoresHaveDrink(String headerValue) {
    final $url = '/stores/drink';
    final $headers = {'token': headerValue};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<List<StoreModel>, StoreModel>($request);
  }

  Future<Response<List<StoreModel>>> getStoreByCategory(
      String headerValue, String categoryId) {
    final $url = '/stores/byCate/$categoryId';
    final $headers = {'token': headerValue};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<List<StoreModel>, StoreModel>($request);
  }

  Future<Response<List<StoreModel>>> getStoreByName(
      String headerValue, String name) {
    final $url = '/stores/search';
    final Map<String, dynamic> $params = {'name': name};
    final $headers = {'token': headerValue};
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<List<StoreModel>, StoreModel>($request);
  }
}
