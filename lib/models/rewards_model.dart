import 'package:flutter/foundation.dart';

class RewardsModelProvider extends ChangeNotifier {
  String clubCode;

  List<Rewards> rewards;

  RewardsModelProvider(String clubCode) {
    this.clubCode = clubCode;
  }

  set setRewards(List<Rewards> rewards) {
    this.rewards = rewards;
    notifyListeners();
  }
}

class RewardsModel {
  List<Rewards> rewards;

  RewardsModel({this.rewards});

  RewardsModel.fromJson(Map<String, dynamic> json) {
    if (json['rewards'] != null) {
      rewards = new List<Rewards>();
      json['rewards'].forEach((v) {
        rewards.add(new Rewards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rewards != null) {
      data['rewards'] = this.rewards.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rewards {
  int id;
  String type;
  int amount;
  String schedule;
  Null startHour;

  Rewards({this.id, this.type, this.amount, this.schedule, this.startHour});

  Rewards.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    amount = json['amount'];
    schedule = json['schedule'];
    startHour = json['startHour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['schedule'] = this.schedule;
    data['startHour'] = this.startHour;
    return data;
  }
}
