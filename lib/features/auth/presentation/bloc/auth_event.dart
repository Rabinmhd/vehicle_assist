abstract class AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String mobileNumber;
  final String otp;

  LoginSubmitted({required this.mobileNumber, required this.otp});
}
