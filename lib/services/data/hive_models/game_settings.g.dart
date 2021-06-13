// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameSettingsAdapter extends TypeAdapter<GameSettings> {
  @override
  final int typeId = 0;

  @override
  GameSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameSettings(
      fields[0] as String,
      fields[1] as bool,
      fields[2] as bool,
      fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GameSettings obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.gameCode)
      ..writeByte(1)
      ..write(obj.muckLosingHand)
      ..writeByte(2)
      ..write(obj.gameSound)
      ..writeByte(3)
      ..write(obj.audioConf);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
