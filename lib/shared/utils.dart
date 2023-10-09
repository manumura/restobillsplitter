import 'dart:io';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/dish_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';

double parseDouble(String value) {
  return double.tryParse(value.replaceFirst(RegExp(r','), '.')) ?? 0.0;
}

Future<File> generateCsv(BillModel bill, DateTime now) async {
  final List<List<dynamic>?> rows = <List<dynamic>?>[];

  // Guests
  final List<dynamic> guestsHeader = <dynamic>[];
  guestsHeader.addAll(<String>[
    'Guest name',
    'Total',
  ]);
  if (bill.tax > 0) {
    guestsHeader.add('Total with tax (${bill.tax}%)');
  }
  rows.add(guestsHeader);

  for (int i = 0; i < bill.guests.length; i++) {
    final List<dynamic> row = <dynamic>[];

    final GuestModel guest = bill.guests[i];
    row.add(guest.name);
    row.add(guest.total);
    if (bill.tax > 0) {
      row.add(
        guest.getTotalWithTax(
          isSplitTaxEqually: bill.isSplitTaxEqually,
          taxAsPercentage: bill.tax,
          taxAsAmount: bill.taxSplitEqually,
        ),
      );
    }

    rows.add(row);
  }

  // Guests total
  final List<dynamic> guestsTotal = <dynamic>[];
  guestsTotal.addAll(<dynamic>['', bill.totalToSplit]);
  if (bill.tax > 0) {
    guestsTotal.add(bill.totalWithTaxToSplit);
  }
  rows.add(guestsTotal);

  // Line break
  rows.add(null);

  // Dishes
  final List<dynamic> dishesHeader = <dynamic>[];
  dishesHeader.addAll(<String>[
    'Dish name',
    'Price',
  ]);
  if (bill.tax > 0) {
    dishesHeader.add('Price with tax (${bill.tax}%)');
  }
  rows.add(dishesHeader);

  for (int i = 0; i < bill.dishes.length; i++) {
    final List<dynamic> row = <dynamic>[];

    final DishModel dish = bill.dishes[i];
    row.add(dish.name);
    row.add(dish.price);
    if (bill.tax > 0) {
      row.add(dish.getPriceWithTax(taxAsPercentage: bill.tax));
    }

    rows.add(row);
  }

  // Dishes total
  final List<dynamic> dishesTotal = <dynamic>[];
  dishesTotal.addAll(<dynamic>['', bill.total]);
  if (bill.tax > 0) {
    dishesTotal.add(bill.totalWithTax);
  }
  rows.add(dishesTotal);

  final String fileSuffix = DateFormat('yyyyMMddHHmmss').format(now);

  // final Directory? directory = await getExternalStorageDirectory();
  final Directory directory = await getApplicationCacheDirectory();
  // if (directory == null) {
  //   logger.d('Cannot find external storage directory');
  //   return;
  // }

  final File file = File('${directory.path}/bill_summary_$fileSuffix.csv');
  // final File file = MemoryFileSystem().file('tmp.csv');
  final String csv = const ListToCsvConverter().convert(rows);
  file.writeAsString(csv);

  return file;
}
