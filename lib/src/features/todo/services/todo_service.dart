import "package:faithwave_app/src/models/todo.dart";
import "package:oxidized/oxidized.dart";

abstract interface class TodoService {
  Future<Result<List<Todo>, Exception>> getTodos(String userId);
  Future<Result<Todo, Exception>> createTodo(String title, String userId);
  Future<Result<Todo, Exception>> toggleTodo(String id, String userId);
  Future<Result<void, Exception>> deleteTodo(String id, String userId);
}
