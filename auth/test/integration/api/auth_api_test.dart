import 'package:auth/src/domain/token.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:auth/src/infra/api/auth_api.dart';
import 'package:auth/src/domain/credential.dart';

void main() {
  http.Client client;
  AuthApi api;
  String baseUrl = "http://localhost:3000";
  
  setUp(() {
    client = http.Client();
    api = AuthApi(baseUrl, client);
  });

  var credential = Credential(type: AuthType.email, email: "newuser@dev.com", password: "123456", name: "new user");

  group('signIn', () {
    test('should return json web token when successful', () async {
      //Act
      var result = await api.signIn(credential);
      //Assert
      expect(result.asValue.value, isNotEmpty);
    });
  });

  group('signOut', () {
    test('should sign out user and return true', () async {
      //Arrange
      var strToken = await api.signIn(credential);
      var token = Token(strToken.asValue.value);

      //Act
      var result = await api.signOut(token);
      //Assert
      expect(result.asValue.value, true);
    });
  });
}