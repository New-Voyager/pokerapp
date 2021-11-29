class AppSettingsModel {
  String playerInGame;
  AppSettingsModel({
    this.playerInGame,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerInGame': playerInGame,
    };
  }

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      playerInGame: json['playerInGame'],
    );
  }
}
