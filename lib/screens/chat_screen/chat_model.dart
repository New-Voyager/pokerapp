import 'package:flutter/foundation.dart';

class ChatModel {
  final int id;
  final int memberID;
  final String messageType;
  final String text;
  final DateTime messageTime;
  final String memberName;
  bool isGroupLatest;
  final CreditUpdateChatModel chatAdjustmentModel;
  final String updatedBy;
  ChatModel({
    this.id,
    this.memberID,
    this.messageType,
    this.text,
    this.messageTime,
    this.memberName,
    this.isGroupLatest,
    this.chatAdjustmentModel,
    this.updatedBy,
  });
}

class CreditUpdateChatModel {
  final CreditUpdateType type;
  final double amount;
  final String text;
  final double credits;
  final double oldCredits;
  final DateTime date;

  CreditUpdateChatModel({
    @required this.type,
    @required this.amount,
    @required this.text,
    @required this.credits,
    @required this.date,
    this.oldCredits,
  });

  /*
      {
        "type": "adjust",
        "amount": -50.0,
        "annotation": "recd via cashapp",
        "credits": 600.30,
        "time":"2022-01-01
      }
      type: adjust, fee_credit, add, deduct, hh, reward
   */
  factory CreditUpdateChatModel.fromJson(Map<String, dynamic> data) {
    return CreditUpdateChatModel(
      type: CreditUpdateTypeParsing.fromString(data['type']),
      amount: double.parse(data['amount'].toString()),
      text: data['annotation'].toString(),
      credits: double.parse(data['credits'].toString()),
      date: DateTime.parse(data['time'].toString()),
    );
  }
}

// type: adjust, fee_credit, add, deduct, hh, reward
enum CreditUpdateType { adjust, fee_credit, add, deduct, reward, hh, set }

extension CreditUpdateTypeParsing on CreditUpdateType {
  String get value =>
      this.toString().split('.').last.split('_').join(' ').toUpperCase();

  static CreditUpdateType fromString(String v) =>
      CreditUpdateType.values.firstWhere(
        (e) => e.toString().split('.').last == v,
        orElse: () => CreditUpdateType.adjust,
      );
}
