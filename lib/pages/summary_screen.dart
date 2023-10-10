import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/models/alert_type.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';
import 'package:restobillsplitter/shared/app_bar.dart';
import 'package:restobillsplitter/shared/side_drawer.dart';
import 'package:restobillsplitter/shared/utils.dart';
import 'package:restobillsplitter/state/providers.dart';
import 'package:restobillsplitter/widgets/helpers/ui_helper.dart';
import 'package:restobillsplitter/widgets/summary_list_tile.dart';
import 'package:share/share.dart';

class SummaryScreen extends ConsumerStatefulWidget {
  const SummaryScreen({super.key});

  static const String routeName = '/summary';

  @override
  ConsumerState<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends ConsumerState<SummaryScreen> {
  final Logger logger = getLogger();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final BillModel bill = ref.watch(billStateNotifierProvider);
    final List<GuestModel> guests = bill.guests;
    final String totalAsString = bill.totalWithTax.toStringAsFixed(2);
    final String totalSplitAsString =
        bill.totalWithTaxToSplit.toStringAsFixed(2);

    return Scaffold(
      drawer: const SideDrawer(),
      appBar: CustomAppBar(
        _buildTitle(totalAsString, totalSplitAsString),
        <Widget>[
          _buildCsvExportButton(bill),
        ],
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
                  key: ValueKey<String>(guest.uuid),
                  guest: guest,
                );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Total: \$$total '),
        Text(
          '(to split: \$$totalSplit)',
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCsvExportButton(BillModel bill) {
    return IconButton(
      icon: _isLoading
          ? const Icon(
              FontAwesomeIcons.fileCsv,
              color: Colors.grey,
            )
          : const Icon(
              FontAwesomeIcons.fileCsv,
              color: Colors.black,
            ),
      onPressed: _isLoading || bill.guests.isEmpty || bill.dishes.isEmpty
          ? null
          : () => _exportToCsv(bill),
    );
  }

  Future<void> _exportToCsv(BillModel bill) async {
    try {
      setState(() => _isLoading = true);

      final DateTime now = DateTime.now();
      final String dateTitle = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      final File file = await generateCsv(bill, now);

      if (!mounted) return;
      final RenderBox? box = context.findRenderObject() as RenderBox?;
      if (box == null) {
        logger.d('Cannot find render box');
        return;
      }

      Share.shareFiles(
        <String>[file.path],
        subject: 'Your Resto Bill Splitter bill summary on $dateTitle',
        text: 'Please find attached the bill summary export as csv file.',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      );
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      UiHelper.showAlertDialog(context, AlertType.error,
          'Csv creation failed !', 'Please try again later.');
      return;
    }
  }
}
