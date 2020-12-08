import 'package:hooks_riverpod/all.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';

class BillStateNotifier extends StateNotifier<BillModel> {
  BillStateNotifier([BillModel initialBill])
      : super(initialBill ?? BillModel(guests: <GuestModel>[]));

  void addGuest() {
    final int nextIndex = state.guests.length + 1;
    final GuestModel guestToAdd = GuestModel(
        uuid: 'TODO',
        name: 'Guest '
            '$nextIndex');
    state = state..guests.add(guestToAdd);
  }
}
