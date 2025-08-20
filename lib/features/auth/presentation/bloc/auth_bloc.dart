import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/models/login_models.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final request = LoginRequest(
        mobileNumber: event.mobileNumber,
        otp: event.otp,
      );
      final response = await authRepository.login(request);
      if (response.accessToken.isNotEmpty) {
        emit(AuthSuccess(
          accessToken: response.accessToken,
          user: response.user,
        ));
      } else {
        emit(AuthFailure(error: 'Authentication failed'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
