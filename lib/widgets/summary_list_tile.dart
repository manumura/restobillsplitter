import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';
import 'package:restobillsplitter/state/providers.dart';

class SummaryListTile extends HookWidget {
  SummaryListTile({@required this.key, @required this.guest})
      : assert(key != null && guest != null);

  final Key key;
  final GuestModel guest;

  final Logger logger = getLogger();

  @override
  Widget build(BuildContext context) {
    final BillModel bill = useProvider(billStateNotifierProvider.state);
    final String total = guest.total?.toStringAsFixed(2) ?? '0.0';
    final String totalWithTax = guest.totalWithTax?.toStringAsFixed(2) ?? '0.0';
    String message = 'has to pay $totalWithTax';
    if (bill.tax != null && bill.tax > 0) {
      message += ' ($total without tax)';
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.0),
      child: ListTile(
        title: Text(
          guest.name,
          // style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        subtitle: Text(
          message,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        // trailing: _buildSelectGuestButton(context, dish),
      ),
    );
  }
}
