import 'package:async/async.dart';

import 'package:auth/src/domain/auth_service_contract.dart';
import 'package:auth/src/domain/signup_service_contract.dart';
import 'package:auth/src/domain/token.dart';
import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/infra/api/auth_api_contract.dart';
import 'package:flutter/cupertino.dart';

class EmailAuth implements IAuthService, ISignUpService {

  final IAuthApi _api;
  Credential _credential;
  EmailAuth(this._api);

  void credential({ @required String email, @required String password }){
    _credential = Credential(type: AuthType.email, email: email, password: password);
  }

  @override
  Future<Result<Token>> signIn() async {
    assert(_credential != null);
    var result = await _api.signIn(_credential);
    if(result.isError) return result.asError;
    return Result.value(Token(result.asValue.value));
  }

  @override
  Future<Result<bool>> signOut(Token token) async {
    return await _api.signOut(token);
  }

  @override
  Future<Result<Token>> signUp(String name, String email, String password) async {
    Credential credential = Credential(type: AuthType.email, email: email, name: name, password: password);
    var result = await _api.signUp(credential);
    if(result.isError) return result.asError;
    return Result.value(Token(result.asValue.value));
  }
  
}