import 'package:restobillsplitter/models/dish_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';

class BillModel {
  BillModel({
    required this.guests,
    required this.dishes,
    required this.tax,
    required this.isSplitTaxEqually,
  });

  List<GuestModel> guests;
  List<DishModel> dishes;
  double tax;
  bool isSplitTaxEqually;

  double get total {
    double total = 0.0;
    for (final DishModel dish in dishes) {
      total += dish.price;
    }

    // Round to 2 decimals
    return double.parse(total.toStringAsFixed(2));
  }

  double get totalWithTax {
    double total = 0.0;
    for (final DishModel dish in dishes) {
      total += dish.price;
    }

    final double totalWithTax = total * (1 + tax / 100);
    // Round to 2 decimals
    return double.parse(totalWithTax.toStringAsFixed(2));
  }

  double get totalToSplit {
    double total = 0.0;
    for (final GuestModel guest in guests) {
      total += guest.total;
    }

    // Round to 2 decimals
    return double.parse(total.toStringAsFixed(2));
  }

  double get totalWithTaxToSplit {
    double totalWithTax = 0.0;
    for (final GuestModel guest in guests) {
      final double guestTotal = guest.getTotalWithTax(
        isSplitTaxEqually: isSplitTaxEqually,
        taxAsPercentage: tax,
        taxAsAmount: taxSplitEqually,
      );
      totalWithTax += guestTotal;
    }

    // Round to 2 decimals
    return double.parse(totalWithTax.toStringAsFixed(2));
  }

  double get taxSplitEqually {
    final double taxSplitEqually = (total * tax / 100) / guests.length;
    // Round to 2 decimals
    return double.parse(taxSplitEqually.toStringAsFixed(2));
  }

  @override
  String toString() {
    return 'BillModel{guests: $guests, dishes:$dishes, tax: $tax, isSplitTaxEqually: $isSplitTaxEqually}';
  }
}
