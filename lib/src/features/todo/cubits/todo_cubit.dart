import "package:equatable/equatable.dart";
import "package:faithwave_app/src/features/auth/cubits/auth_cubit.dart";
import "package:faithwave_app/src/features/todo/services/todo_service.dart";
import "package:faithwave_app/src/models/todo.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:get_it/get_it.dart";
import "package:oxidized/oxidized.dart";

class TodoCubit extends Cubit<TodoState> {
  final TodoService _todoService = GetIt.I.get<TodoService>();
  final AuthCubit _authCubit;

  TodoCubit(this._authCubit) : super(const TodoState()) {
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    if (!_authCubit.state.isAuthenticated) return;

    final userId = _authCubit.state.currentUser.unwrap().email;
    emit(state.toLoading());

    final result = await _todoService.getTodos(userId);
    final nextState = result.match(
      (todos) => state.copyWith(
        isLoading: false,
        error: const None(),
        todos: Some(todos),
      ),
      (error) => state.toError(error.toString()),
    );

    emit(nextState);
  }

  Future<void> createTodo(String title) async {
    if (!_authCubit.state.isAuthenticated) return;

    final userId = _authCubit.state.currentUser.unwrap().email;
    emit(state.toLoading());

    final result = await _todoService.createTodo(title, userId);
    result.match(
      (todo) {
        final currentTodos = state.todos.unwrapOr([]);
        emit(state.copyWith(
          isLoading: false,
          error: const None(),
          todos: Some([todo, ...currentTodos]),
        ),);
      },
      (error) => emit(state.toError(error.toString())),
    );
  }

  Future<void> toggleTodo(String id) async {
    if (!_authCubit.state.isAuthenticated) return;

    final userId = _authCubit.state.currentUser.unwrap().email;
    emit(state.toLoading());

    final result = await _todoService.toggleTodo(id, userId);
    result.match(
      (updatedTodo) {
        final currentTodos = state.todos.unwrapOr([]);
        final updatedTodos = currentTodos.map((todo) {
          return todo.id == id ? updatedTodo : todo;
        }).toList();

        emit(state.copyWith(
          isLoading: false,
          error: const None(),
          todos: Some(updatedTodos),
        ),);
      },
      (error) => emit(state.toError(error.toString())),
    );
  }

  Future<void> deleteTodo(String id) async {
    if (!_authCubit.state.isAuthenticated) return;

    final userId = _authCubit.state.currentUser.unwrap().email;
    emit(state.toLoading());

    final result = await _todoService.deleteTodo(id, userId);
    result.match(
      (_) {
        final currentTodos = state.todos.unwrapOr([]);
        final updatedTodos = currentTodos.where((todo) => todo.id != id).toList();

        emit(state.copyWith(
          isLoading: false,
          error: const None(),
          todos: Some(updatedTodos),
        ),);
      },
      (error) => emit(state.toError(error.toString())),
    );
  }

  void clearError() {
    emit(state.copyWith(error: const None()));
  }
}

class TodoState extends Equatable {
  final bool isLoading;
  final Option<String> error;
  final Option<List<Todo>> todos;

  const TodoState({
    this.isLoading = false,
    this.error = const None(),
    this.todos = const None(),
  });

  bool get hasError => error.isSome();

  TodoState copyWith({
    bool? isLoading,
    Option<String>? error,
    Option<List<Todo>>? todos,
  }) =>
      TodoState(
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        todos: todos ?? this.todos,
      );

  TodoState toLoading() => copyWith(
        isLoading: true,
        error: const None(),
      );

  TodoState toError(String message) => copyWith(
        isLoading: false,
        error: Some(message),
      );

  @override
  List<Object?> get props => [isLoading, error, todos];
}
