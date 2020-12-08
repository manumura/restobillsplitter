import 'package:flutter/foundation.dart';
import 'package:restobillsplitter/models/guest_model.dart';

class BillModel {
  BillModel({
    @required this.guests,
  }) : assert(guests != null);

  List<GuestModel> guests;
}
