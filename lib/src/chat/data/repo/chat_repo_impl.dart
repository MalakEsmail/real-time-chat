import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:realtimechat/src/chat/data/data_source/chat_remote_data_source.dart';
import 'package:realtimechat/src/chat/data/models/message_model.dart';
import 'package:realtimechat/src/chat/domain/repo/chat_repo.dart';
import 'package:realtimechat/src/core/error/failure.dart';
import 'package:realtimechat/src/core/network/network_info.dart';
import 'package:realtimechat/src/core/utils/app_strings.dart';

class ChatRepoImpl extends ChatRepo {
  final NetworkInfo networkInfo;
  final ChatRemoteDataSource chatRemoteDataSource;

  ChatRepoImpl({required this.networkInfo, required this.chatRemoteDataSource});

  @override
  Future<Either<Failure, void>> sendMessage({required String message}) async {
    if (await networkInfo.isConnected) {
      try {
        await chatRemoteDataSource.sendMessage(message: message);
        return const Right(null);
      } on FirebaseException catch (e) {
        return Left(FirebaseFailure(
          message: e.message ?? "Some thing error",
        ));
      }
    } else {
      return Left(NetworkFailure(message: 'connection failed ! , try connect to Internet !'));
    }
  }

  @override
  Stream<Either<Failure, List<MessageModel>>> fetchMessages() async* {
    if (await networkInfo.isConnected) {
      try {
        yield* FirebaseFirestore.instance
            .collection(AppStrings.messagesCollection)
            .orderBy(AppStrings.timestampKey, descending: true)
            .snapshots()
            .map((snapshot) {
          final messages = snapshot.docs.map((doc) => MessageModel.fromFirestore(doc.data())).toList();
          return Right(messages);
        });
      } catch (e) {
        yield Left(FirebaseFailure(message: e.toString()));
      }
    } else {
      yield Left(NetworkFailure(message: 'connection failed ! , try connect to Internet !'));
    }
  }
}
