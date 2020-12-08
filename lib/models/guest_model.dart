import 'package:flutter/foundation.dart';

class GuestModel {
  GuestModel({
    this.uuid,
    @required this.name,
  }) : assert(name != null);

  String uuid;
  String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuestModel &&
          runtimeType == other.runtimeType &&
          uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() {
    return 'GuestModel{uuid: $uuid, name: $name}';
  }
}
