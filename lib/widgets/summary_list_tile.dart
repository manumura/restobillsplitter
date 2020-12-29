import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/models/guest_model.dart';

class SummaryListTile extends HookWidget {
  SummaryListTile({@required this.key, @required this.guest})
      : assert(key != null && guest != null);

  final Key key;
  final GuestModel guest;

  final Logger logger = getLogger();

  @override
  Widget build(BuildContext context) {
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
        subtitle: Text('has to pay \$${guest.total?.toString()}' ?? '\$0.0'),
        // trailing: _buildSelectGuestButton(context, dish),
      ),
    );
  }
}
