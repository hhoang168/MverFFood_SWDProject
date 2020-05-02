// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$CategoryApiService extends CategoryApiService {
  _$CategoryApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = CategoryApiService;

  Future<Response<List<CategoryModel>>> getCategories(String headerValue) {
    final $url = '/categories/';
    final $headers = {'token': headerValue};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<List<CategoryModel>, CategoryModel>($request);
  }
}
