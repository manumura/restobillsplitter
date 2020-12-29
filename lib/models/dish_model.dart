import 'package:flutter/cupertino.dart';
import 'package:restobillsplitter/models/guest_model.dart';

class DishModel {
  DishModel({
    @required this.uuid,
    @required this.name,
    this.price,
    this.guests,
  }) : assert(uuid != null && name != null);

  String uuid;
  String name;
  double price;
  List<GuestModel> guests = <GuestModel>[];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DishModel &&
          runtimeType == other.runtimeType &&
          uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() {
    return 'DishModel{uuid: $uuid, name: $name, price: $price, guests: '
        '$guests}';
  }
}
