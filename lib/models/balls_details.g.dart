// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balls_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BallTypeAdapter extends TypeAdapter<BallType> {
  @override
  final int typeId = 1;

  @override
  BallType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BallType.plain;
      case 1:
        return BallType.beach;
      case 2:
        return BallType.bowling;
      case 3:
        return BallType.cricket;
      case 4:
        return BallType.base;
      case 5:
        return BallType.soccer;
      case 6:
        return BallType.basket;
      case 7:
        return BallType.tennis;
      case 8:
        return BallType.pool;
      default:
        return BallType.plain;
    }
  }

  @override
  void write(BinaryWriter writer, BallType obj) {
    switch (obj) {
      case BallType.plain:
        writer.writeByte(0);
        break;
      case BallType.beach:
        writer.writeByte(1);
        break;
      case BallType.bowling:
        writer.writeByte(2);
        break;
      case BallType.cricket:
        writer.writeByte(3);
        break;
      case BallType.base:
        writer.writeByte(4);
        break;
      case BallType.soccer:
        writer.writeByte(5);
        break;
      case BallType.basket:
        writer.writeByte(6);
        break;
      case BallType.tennis:
        writer.writeByte(7);
        break;
      case BallType.pool:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BallTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
