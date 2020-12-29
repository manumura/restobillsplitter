import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:restobillsplitter/models/dish_model.dart';

class GuestModel {
  GuestModel(
      {@required this.uuid,
      @required this.name,
      @required this.color,
      @required this.total})
      : assert(uuid != null && name != null && color != null && total != null);

  factory GuestModel.cloneWithCalculatedTotal(
      GuestModel guest, List<DishModel> dishes) {
    if (guest == null) {
      return null;
    }

    final double guestTotal = _calculateTotal(guest, dishes);
    return GuestModel(
      uuid: guest.uuid,
      name: guest.name,
      color: guest.color,
      total: guestTotal,
    );
  }

  String uuid;
  String name;
  Color color;
  double total;

  static double _calculateTotal(GuestModel guest, List<DishModel> dishes) {
    if (dishes == null) {
      return 0.0;
    }

    print('For guest ${guest.name}');
    double guestTotal = 0.0;
    for (final DishModel dish in dishes) {
      final double totalForDish = _calculateTotalPerDish(guest, dish);
      print('For dish ${dish.name} : $totalForDish');
      guestTotal += totalForDish;
    }

    print('total $guestTotal');
    // Round to 2 decimals
    return double.parse(guestTotal.toStringAsFixed(2));
  }

  static double _calculateTotalPerDish(GuestModel guest, DishModel dish) {
    double totalForDish = 0.0;
    if (dish.guests == null) {
      return totalForDish;
    }

    if (dish.guests.contains(guest) && dish.price != null) {
      totalForDish = dish.price / dish.guests.length;
    }

    return totalForDish;
  }

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
    return 'GuestModel{uuid: $uuid, name: $name, color: $color, total: $total}';
  }
}
