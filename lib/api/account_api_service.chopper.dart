// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$AccountApiService extends AccountApiService {
  _$AccountApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = AccountApiService;

  Future<Response<List<AccountModel>>> getAccountByUserID(
      String headerValue, String userID) {
    final $url = '/accounts/$userID';
    final $headers = {'token': headerValue};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<List<AccountModel>, AccountModel>($request);
  }
}
