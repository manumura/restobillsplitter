import 'package:flutter/foundation.dart';
import 'package:restobillsplitter/models/dish_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';

class BillModel {
  BillModel({
    @required this.guests,
    @required this.dishes,
  }) : assert(guests != null && dishes != null);

  List<GuestModel> guests;
  List<DishModel> dishes;

  @override
  String toString() {
    return 'BillModel{guests: $guests, dishes:$dishes}';
  }
}
