import 'package:flutter/rendering.dart';
import 'package:restobillsplitter/models/dish_model.dart';

class GuestModel {
  GuestModel({
    required this.uuid,
    required this.name,
    required this.color,
    required this.dishes,
  });

  String uuid;
  String name;
  Color color;
  List<DishModel> dishes;

  double get total {
    double total = 0.0;
    for (final DishModel dish in dishes) {
      if (dish.guestUuids == null || dish.guestUuids!.isEmpty) {
        continue;
      }
      final double totalForDish = dish.price / dish.guestUuids!.length;
      total += totalForDish;
    }
    return total;
  }

  double getTotalWithTax(
      {required bool isSplitTaxEqually,
      required double taxAsPercentage,
      required double taxAsAmount}) {
    final double guestTotalWithTax = isSplitTaxEqually
        ? _calculateTotalWithTaxSplitEqually(taxAsAmount)
        : _calculateTotalWithTax(taxAsPercentage);
    return guestTotalWithTax;
  }

  double _calculateTotalWithTax(double taxAsPercentage) {
    if (taxAsPercentage < 0 || taxAsPercentage > 100) {
      return total;
    }
    return total * (1 + taxAsPercentage / 100);
  }

  double _calculateTotalWithTaxSplitEqually(double taxAsAmount) {
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
    return 'GuestModel{name: $name, total: ${total.roundToDouble()}, dishes: '
        '${dishes.length}';
  }
}
