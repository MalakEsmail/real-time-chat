part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class LoginLoadingState extends AuthState {}

class LoginSuccessfullyState extends AuthState {
  final User? user;

  const LoginSuccessfullyState({required this.user});
}

class LoginErrorState extends AuthState {
  final String errorMessage;

  const LoginErrorState(this.errorMessage);
}

class SignUpLoadingState extends AuthState {}

class SignUpSuccessfullyState extends AuthState {
  final User? user;

  const SignUpSuccessfullyState({required this.user});
}

class SignUpErrorState extends AuthState {
  final String errorMessage;

  const SignUpErrorState(this.errorMessage);
}

class LogoutLoadingState extends AuthState {}

class LogoutSuccessfullyState extends AuthState {}

class LogoutErrorState extends AuthState {
  final String errorMessage;

  const LogoutErrorState(this.errorMessage);
}
