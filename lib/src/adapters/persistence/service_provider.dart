import "package:faithwave_app/src/adapters/persistence/todo_service_persistence.dart";
import "package:faithwave_app/src/features/todo/services/todo_service.dart";
import "package:faithwave_app/src/adapters/mocks/auth_service_mock.dart";
import "package:faithwave_app/src/features/auth/services/auth_service.dart";
import "package:get_it/get_it.dart";
import "package:shared_preferences/shared_preferences.dart";

class PersistenceServiceProvider {
  static Future<void> register() async {
    final prefs = await SharedPreferences.getInstance();

    GetIt.I.registerSingleton<AuthService>(
      AuthServiceMock(),
    );

    GetIt.I.registerSingleton<TodoService>(
      TodoServicePersistence(prefs),
    );
  }
}
