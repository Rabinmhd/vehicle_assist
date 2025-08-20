import '../../domain/models/login_models.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String accessToken;
  final User user;

  AuthSuccess({
    required this.accessToken,
    required this.user,
  });
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});
}
