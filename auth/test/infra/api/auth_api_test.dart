import 'dart:convert';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'package:auth/src/domain/credential.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auth/src/infra/api/auth_api.dart';

class MockClient extends Mock implements http.Client {

}

//arrange
//act
//assert

void main(){
  MockClient client;
  AuthApi api;

  setUp(() {
    client = MockClient();
    api = AuthApi('http:baseUrl', client);
  });

  group('signIn', () {
    var credential = Credential(type: AuthType.email, email: 'email@example.com', password: 'password');

    test('should return error when status code is not 200', () async {
      //arrange
      when(client.post(any, body: anyNamed('body'))).thenAnswer((_) async => http.Response('{}', 404));
      //act
      var result = await api.signIn(credential);
      //assert
      expect(result, isA<ErrorResult>());
    });

    test('should return error when status code is 200 but malformed json', () async {
      //arrange
      when(client.post(any, body: anyNamed('body'))).thenAnswer((_) async => http.Response('{}', 200));
      //act
      var result = await api.signIn(credential);
      //assert
      expect(result, isA<ValueResult>());
    });

    test('should return token string when successful', () async {
      //arrange
      var tokenStr = 'random_string';
      when(client.post(any, body: anyNamed('body'))).thenAnswer((_) async => http.Response(jsonEncode({'auth_token': tokenStr}), 200));
      //act
      var result = await api.signIn(credential);
      //assert
      expect(result.asValue.value, tokenStr);
    });
  });
}