// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$UserApiService extends UserApiService {
  _$UserApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = UserApiService;

  Future<Response<UserModel>> login(LoginModel loginModel, bool isGmail) {
    final $url = '/users/login';
    final Map<String, dynamic> $params = {'isGmail': isGmail};
    final $body = loginModel;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, parameters: $params);
    return client.send<UserModel, UserModel>($request);
  }
}
