import 'package:hooks_riverpod/all.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';

final AutoDisposeStateNotifierProvider<BillStateNotifier>
    billStateNotifierProvider =
    StateNotifierProvider.autoDispose<BillStateNotifier>(
        (ProviderReference ref) {
  return BillStateNotifier();
});
