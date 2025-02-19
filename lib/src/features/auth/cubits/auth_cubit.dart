import "package:equatable/equatable.dart";
import "package:faithwave_app/src/features/auth/services/auth_service.dart";
import "package:faithwave_app/src/models/errors/auth_error.dart";
import "package:faithwave_app/src/models/user.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:get_it/get_it.dart";
import "package:oxidized/oxidized.dart";

class AuthCubit extends Cubit<AuthState> {
  AuthService authService = GetIt.I.get<AuthService>();

  AuthCubit() : super(const AuthState());

  Future<void> signUp(String email, String name, String password) async {
    emit(state.toLoading());
    final result = await authService.signUp(
      email: email,
      name: name,
      password: password,
    );
    final nextState = result.match(
      (user) => state.copyWith(currentUser: Some(user)),
      (error) => state.toError(error),
    );
    emit(nextState);
  }

  Future<void> signIn(String email, String password) async {
    emit(state.toLoading());
    final result = await authService.signIn(
      email: email,
      password: password,
    );
    final nextState = result.match(
      (user) => state.copyWith(currentUser: Some(user)),
      (error) => state.toError(error),
    );
    emit(nextState);
  }

  Future<void> signOut() async {
    emit(state.toLoading());
    final result = await authService.signOut();
    final nextState = result.match(
      (_) => state.copyWith(
        isLoading: false,
        error: const None(),
        currentUser: const None(),
      ),
      (error) => state.toError(error),
    );
    emit(nextState);
  }
}

class AuthState extends Equatable {
  final bool isLoading;
  final Option<AuthError> error;
  final Option<User> currentUser;

  const AuthState({
    this.isLoading = false,
    this.error = const None(),
    this.currentUser = const None(),
  });

  bool get isAuthenticated => currentUser.isSome();
  bool get hasError => error.isSome();
  String get redactedError => switch (error) {
        Some(some: AuthErrorUnknown()) => "Unknown error",
        Some(some: AuthErrorEmailAlreadyInUse()) => "Email already in use",
        Some(some: AuthErrorInvalidCredentials()) => "Invalid credentials",
        None<AuthError>() => "",
      };

  @override
  List<Object?> get props => [
        isLoading,
        error,
        currentUser,
      ];

  AuthState copyWith({
    bool? isLoading,
    Option<AuthError>? error,
    Option<User>? currentUser,
  }) =>
      AuthState(
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        currentUser: currentUser ?? this.currentUser,
      );

  AuthState toLoading() => copyWith(
        isLoading: true,
        error: const None(),
      );
  AuthState toError(AuthError error) => copyWith(
        isLoading: false,
        error: Some(error),
      );
  AuthState toIdle() => copyWith(
        isLoading: false,
        error: const None(),
      );
}
