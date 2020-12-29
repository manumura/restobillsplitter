import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/dish_model.dart';

class GuestModel {
  GuestModel({
    @required this.uuid,
    @required this.name,
    @required this.color,
    this.total,
    this.totalWithTax,
  }) : assert(uuid != null && name != null && color != null);

  factory GuestModel.cloneWithCalculatedTotal(
      GuestModel guest, BillModel bill) {
    if (guest == null) {
      return null;
    }

    print('For guest ${guest.name}');
    final double guestTotal = _calculateTotal(guest, bill.dishes);
    print('total $guestTotal');
    // Round to 2 decimals
    final double guestTotalRounded =
        double.parse(guestTotal.toStringAsFixed(2));

    final double guestTotalWithTax = bill.isSplitTaxEqually
        ? _calculateTotalWithTaxSplitEqually(guestTotal, bill.taxSplitEqually)
        : _calculateTotalWithTax(guestTotal, bill.tax);
    print('total with tax $guestTotalWithTax');
    // Round to 2 decimals
    final double guestTotalWithTaxRounded =
        double.parse(guestTotalWithTax.toStringAsFixed(2));

    return GuestModel(
      uuid: guest.uuid,
      name: guest.name,
      color: guest.color,
      total: guestTotalRounded,
      totalWithTax: guestTotalWithTaxRounded,
    );
  }

  String uuid;
  String name;
  Color color;
  double total;
  double totalWithTax;

  static double _calculateTotal(GuestModel guest, List<DishModel> dishes) {
    if (dishes == null) {
      return 0.0;
    }

    double guestTotal = 0.0;
    for (final DishModel dish in dishes) {
      final double totalForDish = _calculateTotalPerDish(guest, dish);
      print('For dish ${dish.name} : $totalForDish');
      guestTotal += totalForDish;
    }

    // Round to 2 decimals
    return guestTotal;
  }

  static double _calculateTotalWithTax(double total, double taxAsPercentage) {
    if (taxAsPercentage == null ||
        taxAsPercentage < 0 ||
        taxAsPercentage > 100) {
      return total;
    }
    return total * (1 + taxAsPercentage / 100);
  }

  static double _calculateTotalWithTaxSplitEqually(
      double total, double taxAsAmount) {
    if (taxAsAmount == null) {
      return total;
    }
    return total + taxAsAmount;
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
