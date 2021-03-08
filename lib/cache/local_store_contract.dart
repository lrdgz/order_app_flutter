import 'package:auth/auth.dart';

abstract class ILocalStore {
  Future<Token> fetch();
  Future delete(Token token);
}