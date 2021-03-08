import 'dart:convert';

import 'package:async/async.dart';
import 'package:auth/src/domain/token.dart';
import 'package:auth/src/infra/api/mapper.dart';
import 'package:http/http.dart' as http;
import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/infra/api/auth_api_contract.dart';

class AuthApi implements IAuthApi{
  final http.Client _client;
  String baseUrl;

  AuthApi(this.baseUrl, this._client);

  @override
  Future<Result<String>> signIn(Credential credential) async {
    var endpoint = baseUrl + '/auth/signin';
    _client.post(endpoint, body: Mapper.toJson(credential));
    return await _postCredential(endpoint, credential);
  }

  @override
  Future<Result<String>> signUp(Credential credential) async {
    var endpoint = baseUrl + '/auth/signup';
    return await _postCredential(endpoint, credential);
  }

  Future<Result<String>> _postCredential(String endpoint, Credential credential) async {
    var response = await _client.post(endpoint, body:jsonEncode( Mapper.toJson(credential) ), headers: {"Content-type": "application/json"});
    if(response.statusCode != 200) return Result.error("Server Error");
    var json = jsonDecode(response.body);
    return json['auth_token'] != null ? Result.value(json['auth_token']) : Result.value(json['message']);
  }

  @override
  Future<Result<bool>> signOut(Token token) async {
    var url = baseUrl + 'auth/signout';
    var headers = {
      "Content-type": "application/json",
      "Authorization": token.value
    };

    var response = await _client.post(url, headers: headers);
    if(response.statusCode != 200){
      return Result.value(false);
    }
    return Result.value(true);
  }
}