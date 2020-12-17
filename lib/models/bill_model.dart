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

  @override
  String toString() {
    return 'BillModel{guests: $guests, dishes:$dishes, tax: $tax, isSplitTaxEqually: $isSplitTaxEqually}';
  }
}
