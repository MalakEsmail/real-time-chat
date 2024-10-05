import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:realtimechat/src/authentication/data/data_source/auth_local_data_source.dart';
import 'package:realtimechat/src/authentication/data/data_source/auth_remote_data_source.dart';
import 'package:realtimechat/src/authentication/data/repo/auth_repo_impl.dart';
import 'package:realtimechat/src/authentication/presentation/auth_bloc/auth_bloc.dart';
import 'package:realtimechat/src/authentication/presentation/auth_screen.dart';
import 'package:realtimechat/src/core/network/network_info.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Time Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(
                authRepo: AuthRepoImpl(
                    networkInfo: NetworkInfoImpl(internetConnectionChecker: InternetConnectionChecker()),
                    authRemoteDataSource: AuthRemoteDataSourceImpl(),
                    authLocalDataSource: AuthLocalDataSourceImpl(const FlutterSecureStorage()))),
          ),
        ],
        child: const AuthScreen(),
      ),
    );
  }
}
