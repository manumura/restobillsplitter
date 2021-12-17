import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';
import 'package:restobillsplitter/pages/summary_guest_details_screen.dart';
import 'package:restobillsplitter/state/providers.dart';

class SummaryListTile extends HookConsumerWidget {
  SummaryListTile({required this.key, required this.guest});

  final Key key;
  final GuestModel guest;

  final Logger logger = getLogger();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BillModel bill = ref.watch(billStateNotifierProvider);
    final String totalAsString = guest.total.toStringAsFixed(2);
    final double totalWithTax = guest.getTotalWithTax(
      isSplitTaxEqually: bill.isSplitTaxEqually,
      taxAsPercentage: bill.tax,
      taxAsAmount: bill.taxSplitEqually,
    );
    final String totalWithTaxAsString = totalWithTax.toStringAsFixed(2);
    String message = 'has to pay \$$totalWithTaxAsString';
    if (bill.tax > 0) {
      message += ' (\$$totalAsString without tax)';
    }

    final Widget trailingWidget = (guest.dishes.isNotEmpty)
        ? const Icon(FontAwesomeIcons.chevronRight)
        : const SizedBox();

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
        trailing: trailingWidget,
        onTap: (guest.dishes.isNotEmpty)
            ? () => _showGuestDetails(context, guest)
            : null,
        // trailing: _buildSelectGuestButton(context, dish),
      ),
    );
  }

  void _showGuestDetails(BuildContext context, GuestModel guest) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings:
            const RouteSettings(name: SummaryGuestDetailsScreen.routeName),
        builder: (BuildContext context) => SummaryGuestDetailsScreen(guest),
      ),
    );
  }
}
