import 'package:flutter/foundation.dart';
import 'package:pokerapp/services/app/rewards_service.dart';

class RewardsModelProvider extends ChangeNotifier {
  String clubCode;

  List<Rewards> rewards;

  RewardsModelProvider(String clubCode) {
    this.clubCode = clubCode;
    getRewards();
  }

  getRewards() async {
    this.rewards = await RewardService.getRewards(this.clubCode);
    notifyListeners();
  }

  createRewards(String name, String schedule, int amount, String type) async {
    await RewardService.createReward(
        name, schedule, amount, type, this.clubCode);
    rewards = null;
    notifyListeners();
    await getRewards();
    notifyListeners();
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
  String name;

  Rewards(
      {this.id,
      this.type,
      this.amount,
      this.schedule,
      this.startHour,
      this.name});

  Rewards.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    amount = json['amount'];
    schedule = json['schedule'];
    startHour = json['startHour'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['schedule'] = this.schedule;
    data['startHour'] = this.startHour;
    data['name'] = this.name;
    return data;
  }
}
