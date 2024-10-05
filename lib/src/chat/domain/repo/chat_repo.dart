import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:realtimechat/src/core/error/failure.dart';

abstract class ChatRepo {
  Future<Either<Failure, void>> sendMessage({required String message});

  Stream<Either<Failure, List<DocumentSnapshot>>> fetchMessages();
}
