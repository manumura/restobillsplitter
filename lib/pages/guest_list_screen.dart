import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';
import 'package:restobillsplitter/shared/side_drawer.dart';
import 'package:restobillsplitter/state/providers.dart';
import 'package:restobillsplitter/widgets/guest_list_tile.dart';

class GuestListScreen extends HookWidget {
  static const String routeName = '/guest_list';

  @override
  Widget build(BuildContext context) {
    final BillModel bill = useProvider(billStateNotifierProvider.state);
    final List<GuestModel> guests = bill.guests;

    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: const Text('Guests'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        actions: <Widget>[
          _buildAddGuestButton(context),
        ],
      ),
      body: guests.isEmpty
          ? const Center(
              child: Text('Please add a guest first'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) {
                final GuestModel guest = guests[index];
                return GuestListTile(
                    key: ValueKey<String>(guest.uuid), guest: guest);
              },
              itemCount: guests.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                thickness: 2.0,
              ),
            ),
    );
  }

  Widget _buildAddGuestButton(BuildContext context) {
    return TextButton.icon(
      label: const Text('ADD'),
      icon: const Icon(
        Icons.add,
        // color: Colors.white,
      ),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey;
            } else {
              return Colors.black;
            }
          },
        ),
      ),
      onPressed: () => _addGuest(context),
    );
  }

  void _addGuest(BuildContext context) {
    final BillStateNotifier billStateNotifier =
        context.read(billStateNotifierProvider);
    billStateNotifier.addGuest();
  }
}
