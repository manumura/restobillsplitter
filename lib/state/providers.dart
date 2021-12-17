import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';
import 'package:restobillsplitter/models/bill_model.dart';

final StateNotifierProvider<BillStateNotifier, BillModel>
    billStateNotifierProvider =
    StateNotifierProvider<BillStateNotifier, BillModel>(
        (StateNotifierProviderRef<BillStateNotifier, BillModel> ref) {
  return BillStateNotifier();
});
