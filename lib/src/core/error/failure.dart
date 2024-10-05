import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  late final String message;

  @override
  List<Object?> get props => [message];
}

class FirebaseFailure extends Failure {
  @override
  final String message;

  FirebaseFailure({required this.message});
}

class NetworkFailure extends Failure {
  @override
  final String message;

  NetworkFailure({required this.message});
}
