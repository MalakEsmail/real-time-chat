part of 'chat_bloc.dart';

class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatEvent {
  String message;

  SendMessageEvent({required this.message});

}
