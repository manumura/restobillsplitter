import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:restobillsplitter/models/dish_model.dart';

class GuestModel {
  GuestModel({
    @required this.uuid,
    @required this.name,
    @required this.color,
    @required this.dishes,
  }) : assert(uuid != null && name != null && color != null && dishes != null);

  String uuid;
  String name;
  Color color;
  List<DishModel> dishes;

  double get total {
    double total = 0.0;
    for (final DishModel dish in dishes) {
      final double totalForDish = dish != null && dish.price != null
          ? dish.price / dish.guestUuids.length
          : 0;
      total += totalForDish;
    }
    return total;
  }

  double getTotalWithTax(
      {@required bool isSplitTaxEqually, @required double tax}) {
    final double guestTotalWithTax = isSplitTaxEqually
        ? _calculateTotalWithTaxSplitEqually(total, tax)
        : _calculateTotalWithTax(total, tax);
    return guestTotalWithTax;
  }

  double _calculateTotalWithTax(double total, double taxAsPercentage) {
    if (taxAsPercentage == null ||
        taxAsPercentage < 0 ||
        taxAsPercentage > 100) {
      return total;
    }
    return total * (1 + taxAsPercentage / 100);
  }

  double _calculateTotalWithTaxSplitEqually(double total, double taxAsAmount) {
    if (taxAsAmount == null) {
      return total;
    }
    return total + taxAsAmount;
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
    return 'GuestModel{uuid: $uuid, name: $name, color: $color, total: $total, dishes: $dishes}';
  }
}
