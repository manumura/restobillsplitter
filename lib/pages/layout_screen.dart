import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/state/providers.dart';

class LayoutScreen extends HookWidget {
  static const String routeName = '/layout';

  @override
  Widget build(BuildContext context) {
    final BillModel bill = useProvider(billStateNotifierProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Layout'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Text('Number of guests'),
              IconButton(
                icon: Icon(Icons.remove_circle_sharp),
                onPressed: () {
                  print('dec');
                },
              ),
              Text('1'),
              IconButton(
                icon: Icon(Icons.add_circle_sharp),
                onPressed: () {
                  print('inc');
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
