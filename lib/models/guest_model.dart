class GuestModel {
  GuestModel({
    this.uuid,
    this.name,
  }) : assert(name != null);

  String uuid;
  String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuestModel &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'GuestModel{uuid: $uuid, name: $name}';
  }
}
