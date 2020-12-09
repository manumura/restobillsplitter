import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class GuestModel {
  GuestModel({
    @required this.uuid,
    @required this.name,
    @required this.color,
  }) : assert(uuid != null && name != null && color != null);

  String uuid;
  String name;
  Color color;

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
    return 'GuestModel{uuid: $uuid, name: $name, color: $color}';
  }
}
