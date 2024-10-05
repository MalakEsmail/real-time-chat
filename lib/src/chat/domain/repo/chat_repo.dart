import 'package:dartz/dartz.dart';
import 'package:realtimechat/src/chat/data/models/message_model.dart';
import 'package:realtimechat/src/core/error/failure.dart';

abstract class ChatRepo {
  Future<Either<Failure, void>> sendMessage({required String message});

  Stream<Either<Failure, List<MessageModel>>> fetchMessages();
}
