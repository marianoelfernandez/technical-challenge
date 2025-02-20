import "dart:convert";

import "package:faithwave_app/src/features/auth/services/auth_service.dart";
import "package:faithwave_app/src/models/errors/auth_error.dart";
import "package:faithwave_app/src/models/user.dart";
import "package:oxidized/oxidized.dart";
import "package:shared_preferences/shared_preferences.dart";

class AuthServicePersistence implements AuthService {
  static const String _userKey = "current_user";
  static const String _credentialsKey = "user_credentials";

  final SharedPreferences _prefs;

  AuthServicePersistence(this._prefs);

  @override
  Future<Result<User, AuthError>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credentialsJson = _prefs.getString(_credentialsKey);
      if (credentialsJson == null) {
        return Err(AuthErrorInvalidCredentials());
      }

      final credentials = Map<String, String>.from(
        jsonDecode(credentialsJson),
      );

      if (!credentials.containsKey(email) || credentials[email] != password) {
        return Err(AuthErrorInvalidCredentials());
      }

      final userJson = _prefs.getString(_userKey);
      if (userJson == null) {
        return Err(AuthErrorUnknown());
      }

      final users = Map<String, dynamic>.from(
        jsonDecode(userJson),
      );

      if (!users.containsKey(email)) {
        return Err(AuthErrorUnknown());
      }

      final user = User.fromJson(users[email]);

      return Ok(user);
    } catch (ex) {
      return Err(AuthErrorUnknown());
    }
  }

  @override
  Future<Result<void, AuthError>> signOut() async {
    try {
      await _prefs.remove(_userKey);
      return const Ok(null);
    } catch (ex) {
      return Err(AuthErrorUnknown());
    }
  }

  @override
  Future<Result<User, AuthError>> signUp({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      final credentialsJson = _prefs.getString(_credentialsKey);
      final userJson = _prefs.getString(_userKey);

      Map<String, String> credentials = {};
      Map<String, dynamic> users = {};

      if (credentialsJson != null) {
        credentials = Map<String, String>.from(
          jsonDecode(credentialsJson),
        );
      }

      if (userJson != null) {
        users = Map<String, dynamic>.from(
          jsonDecode(userJson),
        );
      }

      if (credentials.containsKey(email)) {
        return Err(AuthErrorEmailAlreadyInUse());
      }

      final user = User(
        name: name,
        email: email,
      );

      credentials[email] = password;
      users[email] = user.toJson();

      await Future.wait([
        _prefs.setString(_credentialsKey, jsonEncode(credentials)),
        _prefs.setString(_userKey, jsonEncode(users)),
      ]);

      return Ok(user);
    } catch (ex) {
      return Err(AuthErrorUnknown());
    }
  }
}
