import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realtimechat/src/core/utils/app_strings.dart';

class MessageModel {
  final String text;
  final String senderId;
  final Timestamp?  time;

  MessageModel({required this.text, required this.senderId, required this.time});

  factory MessageModel.fromFirestore(Map<String, dynamic> json) {
    return MessageModel(
      text: json[AppStrings.textKey],
      senderId: json[AppStrings.senderIdKey],
      time: (json[AppStrings.timestampKey] ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      AppStrings.textKey: text,
      AppStrings.senderIdKey: senderId,
      AppStrings.timestampKey: time,
    };
  }
}
