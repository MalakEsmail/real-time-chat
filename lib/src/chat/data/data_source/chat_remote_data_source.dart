import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:realtimechat/src/core/utils/app_strings.dart';

abstract class ChatRemoteDataSource {
  Future<void> sendMessage({required String message});
}

class ChatRemoteDataSourceImpl extends ChatRemoteDataSource {
  @override
  Future<void> sendMessage({
    required String message,
  }) async {
    await FirebaseFirestore.instance.collection(AppStrings.messagesCollection).add({
      AppStrings.textKey: message,
      AppStrings.senderIdKey: FirebaseAuth.instance.currentUser!.uid,
      AppStrings.timestampKey: FieldValue.serverTimestamp(),
    });
  }
}
