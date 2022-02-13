enum ApprovalType { APPROVED, DENIED }
enum BombPotIntervalType { EVERY_X_HANDS, TIME_INTERVAL }

extension BombPotIntervalTypeSerialization on BombPotIntervalType {
  String toJson() => this.toString().split(".").last;
  static BombPotIntervalType fromJson(String s) =>
      BombPotIntervalType.values.firstWhere((type) => type.toJson() == s);
}
