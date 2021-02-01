class PlayerInfo {
  int id;
  String uuid;
  String name;

  static PlayerInfo fromJson(dynamic data) {
    PlayerInfo info = new PlayerInfo();
    info.id = int.parse(data['id'].toString());
    info.uuid = data['uuid'].toString();
    info.name = data['name'].toString();
    return info;
  }
}
