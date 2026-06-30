// GENERATED CODE – run `flutter pub run build_runner build` to regenerate
// ignore_for_file: type=lint
part of 'saved_event_model.dart';

class SavedEventModelAdapter extends TypeAdapter<SavedEventModel> {
  @override
  final int typeId = 1;

  @override
  SavedEventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedEventModel(
      id:            fields[0] as String,
      name:          fields[1] as String,
      imageUrl:      fields[2] as String,
      location:      fields[3] as String,
      formattedDate: fields[4] as String,
      localTime:     fields[5] as String,
      type:          fields[6] as String,
      userEmail:     fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SavedEventModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.name)
      ..writeByte(2)..write(obj.imageUrl)
      ..writeByte(3)..write(obj.location)
      ..writeByte(4)..write(obj.formattedDate)
      ..writeByte(5)..write(obj.localTime)
      ..writeByte(6)..write(obj.type)
      ..writeByte(7)..write(obj.userEmail);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedEventModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
