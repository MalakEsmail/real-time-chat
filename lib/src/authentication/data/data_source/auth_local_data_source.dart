import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:realtimechat/src/core/utils/app_strings.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken({required String token});

  Future<String?> getToken();
}

class AuthLocalDataSourceImpl extends AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl(this.secureStorage);

  @override
  Future<void> cacheToken({required String token}) async {
    return await secureStorage.write(key: AppStrings.token, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: AppStrings.token);
  }
}
