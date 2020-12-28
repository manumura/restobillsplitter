import 'package:flutter/foundation.dart';
import 'package:restobillsplitter/models/dish_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';

class BillModel {
  BillModel({
    @required this.guests,
    @required this.dishes,
    @required this.tax,
    @required this.isSplitTaxEqually,
  }) : assert(guests != null &&
            dishes != null &&
            tax != null &&
            isSplitTaxEqually != null);

  List<GuestModel> guests;
  List<DishModel> dishes;
  double tax;
  bool isSplitTaxEqually;

  double get total {
    if (dishes == null) {
      return 0.0;
    }

    double total = 0.0;
    for (final DishModel dish in dishes) {
      if (dish.price == null) {
        continue;
      }

      total += dish.price;
    }

    // Round to 2 decimals
    return double.parse(total.toStringAsFixed(2));
  }

  double get totalSplit {
    if (guests == null) {
      return 0.0;
    }

    double total = 0.0;
    for (final GuestModel guest in guests) {
      if (guest.total == null) {
        continue;
      }

      total += guest.total;
    }

    // Round to 2 decimals
    return double.parse(total.toStringAsFixed(2));
  }

  @override
  String toString() {
    return 'BillModel{guests: $guests, dishes:$dishes, tax: $tax, isSplitTaxEqually: $isSplitTaxEqually}';
  }
}
