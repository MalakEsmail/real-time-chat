import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:realtimechat/src/chat/data/data_source/chat_remote_data_source.dart';
import 'package:realtimechat/src/chat/domain/repo/chat_repo.dart';
import 'package:realtimechat/src/core/error/failure.dart';
import 'package:realtimechat/src/core/network/network_info.dart';

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
}
