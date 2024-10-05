import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtimechat/src/authentication/domain/repo/auth_repo.dart';
import 'package:realtimechat/src/core/error/failure.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;

  AuthBloc({required this.authRepo}) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<SignUpEvent>(_onSignUpEvent);
    on<LogoutEvent>(_onLogoutEvent);
  }

  _onLoginEvent(event, emit) async {
    emit(LoginLoadingState());
    Either<Failure, User?> response = await authRepo.login(email: event.email, password: event.password);
    emit(response.fold((failure) => LoginErrorState(failure.message), (user) => LoginSuccessfullyState(user: user)));
  }

  _onSignUpEvent(event, emit) async {
    emit(SignUpLoadingState());
    Either<Failure, User?> response = await authRepo.signUp(email: event.email, password: event.password);
    emit(response.fold((failure) => SignUpErrorState(failure.message), (user) => SignUpSuccessfullyState(user: user)));
  }

  _onLogoutEvent(event, emit) async {
    emit(LogoutLoadingState());
    Either<Failure, void> response = await authRepo.logout();
    emit(response.fold((failure) => LogoutErrorState(failure.message), (x) => LogoutSuccessfullyState()));
  }
}
