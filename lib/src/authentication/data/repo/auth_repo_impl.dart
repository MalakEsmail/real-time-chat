import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:realtimechat/src/authentication/data/data_source/auth_local_data_source.dart';
import 'package:realtimechat/src/authentication/data/data_source/auth_remote_data_source.dart';
import 'package:realtimechat/src/authentication/domain/repo/auth_repo.dart';
import 'package:realtimechat/src/core/error/failure.dart';
import 'package:realtimechat/src/core/network/network_info.dart';

class AuthRepoImpl extends AuthRepo {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepoImpl({required this.networkInfo, required this.authRemoteDataSource, required this.authLocalDataSource});

  @override
  Future<Either<Failure, User?>> login({required String email, required String password}) async {
    if (await networkInfo.isConnected) {
      try {
        User? user = await authRemoteDataSource.login(email: email, password: password);
        String? token = await user!.getIdToken();
        authLocalDataSource.cacheToken(token: token!);
        return Right(user);
      } on FirebaseAuthException catch (e) {
        return Left(FirebaseFailure(
          message: e.message ?? "Some thing error",
        ));
      }
    } else {
      return Left(NetworkFailure(message: 'connection failed ! , try connect to Internet !'));
    }
  }

  @override
  Future<Either<Failure, User?>> signUp({required String email, required String password}) async {
    if (await networkInfo.isConnected) {
      try {
        User? user = await authRemoteDataSource.signUp(email: email, password: password);
        String? token = await user!.getIdToken();
        authLocalDataSource.cacheToken(token: token!);
        return Right(user);
      } on FirebaseAuthException catch (e) {
        return Left(FirebaseFailure(
          message: e.message ?? "Some thing error",
        ));
      }
    } else {
      return Left(NetworkFailure(message: 'connection failed ! , try connect to Internet !'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        await authRemoteDataSource.logout();
        return const Right(null);
      } on FirebaseAuthException catch (e) {
        return Left(FirebaseFailure(
          message: e.message ?? "Some thing error",
        ));
      }
    } else {
      return Left(NetworkFailure(message: 'connection failed ! , try connect to Internet !'));
    }
  }
}
