part of 'chat_bloc.dart';

@immutable
class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ChatInitial extends ChatState {}

final class LoadingSentMessage extends ChatState {}

final class SuccessSendMessage extends ChatState {}

final class ErrorSendMessage extends ChatState {
  final String errorMessage;

  ErrorSendMessage({required this.errorMessage});
}

final class LoadingFetchMessages extends ChatState {}

final class LoadedFetchMessages extends ChatState {
  final List<DocumentSnapshot> messages;

  LoadedFetchMessages({required this.messages});
}

final class ErrorFetchMessages extends ChatState {
  final String errorMessage;

  ErrorFetchMessages({required this.errorMessage});
}
