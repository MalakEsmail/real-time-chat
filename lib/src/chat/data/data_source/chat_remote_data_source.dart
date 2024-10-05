import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:realtimechat/src/core/utils/app_strings.dart';

abstract class ChatRemoteDataSource {
  Future<void> sendMessage({required String message});

  Future<List<DocumentSnapshot>> fetchMessages();
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

  @override
 Future<List<DocumentSnapshot<Object?>>> fetchMessages() async {
    List<DocumentSnapshot> messages = [];
    final messagesStream =
        FirebaseFirestore.instance.collection(AppStrings.messagesCollection).orderBy(AppStrings.timestampKey, descending: true).snapshots();
    await for (final snapshot in messagesStream) {
      messages = snapshot.docs;
    }
    print("----------messages:$messages");
    return messages;
  }
}
