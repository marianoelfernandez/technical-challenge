import "dart:async";

import "package:faithwave_app/src/adapters/mocks/auth_service_mock.dart";
import "package:faithwave_app/src/features/auth/services/auth_service.dart";
import "package:get_it/get_it.dart";
import "package:shared_preferences/shared_preferences.dart";

Future<void> setupDI() async {
  // Use the GetIt package to register your dependencies.
  final getIt = GetIt.instance;

  // Set up instances
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.reload();
  AuthService authService = AuthServiceMock();

  getIt
    ..registerSingleton<SharedPreferences>(
      sharedPreferences,
    )
    ..registerSingleton<AuthService>(authService);
}
