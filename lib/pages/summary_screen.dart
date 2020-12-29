import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';
import 'package:restobillsplitter/shared/side_drawer.dart';
import 'package:restobillsplitter/state/providers.dart';
import 'package:restobillsplitter/widgets/summary_list_tile.dart';

class SummaryScreen extends HookWidget {
  static const String routeName = '/summary';

  final Logger logger = getLogger();

  @override
  Widget build(BuildContext context) {
    final BillModel bill = useProvider(billStateNotifierProvider.state);
    final List<GuestModel> guests = bill.guests;
    final String totalAsString =
        bill.totalWithTax?.toStringAsFixed(2) ?? '0.00';
    final String totalSplitAsString =
        bill.totalWithTaxToSplit?.toStringAsFixed(2) ?? '0.00';

    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: _buildTitle(totalAsString, totalSplitAsString),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: guests.isEmpty
          ? const Center(
              child: Text('Please add a guest first'),
            )
          // https://medium.com/swlh/flutter-slivers-and-customscrollview-1aaadf96e35a
          // https://flutteragency.com/nestedscrollview-widget/
          : ListView.separated(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) {
                final GuestModel guest = guests[index];
                return SummaryListTile(
                    key: ValueKey<String>(guest.uuid), guest: guest);
              },
              itemCount: guests.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                height: 5.0,
              ),
            ),
    );
  }

  Widget _buildTitle(String total, String totalSplit) {
    return RichText(
      text: TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: 'Total: \$$total ',
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Raleway',
              fontSize: 20.0,
              // fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: '(to split: \$$totalSplit)',
            style: const TextStyle(
              color: Colors.red,
              fontFamily: 'Raleway',
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
