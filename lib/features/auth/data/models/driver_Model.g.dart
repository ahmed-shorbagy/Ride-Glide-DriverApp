// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_Model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DriverModelAdapter extends TypeAdapter<DriverModel> {
  @override
  final int typeId = 1;

  @override
  DriverModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DriverModel(
      name: fields[0] as String?,
      fullName: fields[9] as String?,
      city: fields[8] as String?,
      oTp: fields[7] as String?,
      email: fields[1] as String?,
      password: fields[2] as String?,
      phone: fields[3] as String,
      gender: fields[4] as String?,
      adress: fields[5] as String?,
      imageUrl: fields[6] as String?,
    )
      ..carType = fields[10] as String?
      ..carColor = fields[11] as String?;
  }

  @override
  void write(BinaryWriter writer, DriverModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.adress)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.oTp)
      ..writeByte(8)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.fullName)
      ..writeByte(10)
      ..write(obj.carType)
      ..writeByte(11)
      ..write(obj.carColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
