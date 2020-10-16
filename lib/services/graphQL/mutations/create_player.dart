import 'package:pokerapp/models/auth_model.dart';

class CreatePlayer {
  static String createPlayer(AuthModel authModel) => """
  mutation {
  createPlayer(player: {
    name: "${authModel.name}"
    ${authModel.email == null ? '' : 'email: "${authModel.email}"'}
    ${authModel.deviceID == null ? '' : 'deviceId: "${authModel.deviceID}"'}
    ${authModel.password == null ? '' : 'password: "${authModel.password}"'}
  })
  }
  """;
}
