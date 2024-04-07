// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerDataAdapter extends TypeAdapter<PlayerData> {
  @override
  final int typeId = 0;

  @override
  PlayerData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerData(
      ballType: fields[0] as BallType,
      ownedBalls: (fields[1] as List).cast<BallType>(),
      coins: fields[2] as int,
      completedLevels: (fields[3] as Map).cast<int, int>(),
      powerUps: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.ballType)
      ..writeByte(1)
      ..write(obj.ownedBalls)
      ..writeByte(2)
      ..write(obj.coins)
      ..writeByte(3)
      ..write(obj.completedLevels)
      ..writeByte(4)
      ..write(obj.powerUps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
