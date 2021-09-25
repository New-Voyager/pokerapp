class PlayerRole {
  bool isHost;
  bool isOwner;
  bool isManager;
  static PlayerRole fromJson(dynamic data) {
    PlayerRole role = new PlayerRole();
    role.isHost = data['isHost'];
    role.isOwner = data['isOwner'];
    role.isManager = data['isManager'];
    return role;
  }
}

class PlayerInfo {
  int id;
  String uuid;
  String name;
  PlayerRole role;
  String channel;

  PlayerInfo({
    this.id,
    this.uuid,
    this.name,
    this.role,
    this.channel,
  });

  static PlayerInfo fromJson(dynamic data) {
    PlayerInfo info = new PlayerInfo();
    var playerInfo = data['myInfo'];

    info.id = int.parse(playerInfo['id'].toString());
    info.uuid = playerInfo['uuid'].toString();
    info.name = playerInfo['name'].toString();
    info.channel = playerInfo['channel'].toString();

    if (data['role'] != null) {
      info.role = PlayerRole.fromJson(data['role']);
    }
    return info;
  }

  bool isAdmin() {
    if (role == null) {
      return true;
    }
    return role.isHost || role.isOwner || role.isManager;
  }
}

class PlayerNotes {
  int playerId;
  String playerUuid;
  String notes;
}

class MyPlayerNotes {
  List<PlayerNotes> players = [];
  Map<int, PlayerNotes> playersMap = Map<int, PlayerNotes>();
  MyPlayerNotes();

  factory MyPlayerNotes.fromJson(dynamic data) {
    MyPlayerNotes playersNotes = MyPlayerNotes();
    for (dynamic notes in data) {
      final player = PlayerNotes();
      player.notes = notes['notes'];
      player.playerId = int.parse(notes['playerId'].toString());
      player.playerUuid = notes['playerUuid'];
      playersNotes.players.add(player);
      playersNotes.playersMap[player.playerId] = player;
    }
    return playersNotes;
  }
}
