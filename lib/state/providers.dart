import 'package:hooks_riverpod/all.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';

final StateNotifierProvider<BillStateNotifier> billStateNotifierProvider =
    StateNotifierProvider<BillStateNotifier>((ProviderReference ref) {
  return BillStateNotifier();
});
