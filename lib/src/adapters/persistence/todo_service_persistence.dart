import "dart:convert";

import "package:faithwave_app/src/features/todo/services/todo_service.dart";
import "package:faithwave_app/src/models/todo.dart";
import "package:oxidized/oxidized.dart";
import "package:shared_preferences/shared_preferences.dart";

class TodoServicePersistence implements TodoService {
  static const String _todosKey = "todos";
  final SharedPreferences _prefs;

  TodoServicePersistence(this._prefs);

  @override
  Future<Result<Todo, Exception>> createTodo(
    String title,
    String userId,
  ) async {
    try {
      final todo = Todo.create(
        title: title,
        userId: userId,
      );

      final todosJson = _prefs.getString(_todosKey);
      final List<Todo> todos;

      if (todosJson != null) {
        final List<dynamic> jsonList = jsonDecode(todosJson);
        todos = jsonList.map((json) => Todo.fromJson(json)).toList();
      } else {
        todos = [];
      }

      todos.add(todo);
      await _prefs.setString(
        _todosKey,
        jsonEncode(todos.map((t) => t.toJson()).toList()),
      );

      return Ok(todo);
    } catch (e) {
      return Err(Exception("Failed to create todo"));
    }
  }

  @override
  Future<Result<void, Exception>> deleteTodo(String id, String userId) async {
    try {
      final todosJson = _prefs.getString(_todosKey);
      if (todosJson == null) {
        return const Ok(null);
      }

      final List<dynamic> jsonList = jsonDecode(todosJson);
      final todos = jsonList.map((json) => Todo.fromJson(json)).toList();

      todos.removeWhere((todo) => todo.id == id && todo.userId == userId);
      await _prefs.setString(
        _todosKey,
        jsonEncode(todos.map((t) => t.toJson()).toList()),
      );

      return const Ok(null);
    } catch (e) {
      return Err(Exception("Failed to delete todo"));
    }
  }

  @override
  Future<Result<List<Todo>, Exception>> getTodos(String userId) async {
    try {
      final todosJson = _prefs.getString(_todosKey);
      if (todosJson == null) {
        return const Ok([]);
      }

      final List<dynamic> jsonList = jsonDecode(todosJson);
      final todos = jsonList
          .map((json) => Todo.fromJson(json))
          .where((todo) => todo.userId == userId)
          .toList();

      todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Ok(todos);
    } catch (e) {
      return Err(Exception("Failed to get todos"));
    }
  }

  @override
  Future<Result<Todo, Exception>> toggleTodo(String id, String userId) async {
    try {
      final todosJson = _prefs.getString(_todosKey);
      if (todosJson == null) {
        return Err(Exception("Todo not found"));
      }

      final List<dynamic> jsonList = jsonDecode(todosJson);
      final todos = jsonList.map((json) => Todo.fromJson(json)).toList();

      final todoIndex =
          todos.indexWhere((t) => t.id == id && t.userId == userId);
      if (todoIndex == -1) {
        return Err(Exception("Todo not found"));
      }

      final todo = todos[todoIndex];
      final updatedTodo = todo.copyWith(isDone: !todo.isDone);
      todos[todoIndex] = updatedTodo;

      await _prefs.setString(
        _todosKey,
        jsonEncode(todos.map((t) => t.toJson()).toList()),
      );

      return Ok(updatedTodo);
    } catch (e) {
      return Err(Exception("Failed to toggle todo"));
    }
  }
}
