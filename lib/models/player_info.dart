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
}
