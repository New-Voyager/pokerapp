import 'package:flutter/foundation.dart';

class ChatModel {
  final int id;
  final int memberID;
  final String messageType;
  final String text;
  final DateTime messageTime;
  final String memberName;
  bool isGroupLatest;
  final ChatAdjustmentModel chatAdjustmentModel;

  ChatModel({
    this.id,
    this.memberID,
    this.messageType,
    this.text,
    this.messageTime,
    this.memberName,
    this.isGroupLatest,
    this.chatAdjustmentModel,
  });
}

class ChatAdjustmentModel {
  final ChatAdjustType type;
  final double amount;
  final String text;
  final double credits;
  final DateTime date;

  ChatAdjustmentModel({
    @required this.type,
    @required this.amount,
    @required this.text,
    @required this.credits,
    @required this.date,
  });
}

// type: adjust, fee_credit, add, deduct, hh, reward
enum ChatAdjustType { adjust, fee_credit, add, deduct, reward, hh }

extension ChatAdjustTypeParsing on ChatAdjustType {
  String get value =>
      this.toString().split('.').last.split('_').join(' ').toUpperCase();

  static ChatAdjustType fromString(String v) =>
      ChatAdjustType.values.firstWhere(
        (e) => e.toString().split('.').last == v,
        orElse: () => ChatAdjustType.adjust,
      );
}
