import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:realtimechat/src/chat/domain/repo/chat_repo.dart';
import 'package:realtimechat/src/core/error/failure.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatRepo chatRepo;

  ChatBloc({required this.chatRepo}) : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessageEvent);
  }

  _onSendMessageEvent(event, emit) async {
    emit(LoadingSentMessage());
    Either<Failure, void> response = await chatRepo.sendMessage(
      message: event.message,
    );
    emit(response.fold((failure) => ErrorSendMessage(errorMessage: failure.message), (user) => SuccessSendMessage()));
  }
}
