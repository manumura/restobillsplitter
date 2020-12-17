import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/dish_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';
import 'package:restobillsplitter/state/providers.dart';

class AssignGuestToDishDialog extends StatefulHookWidget {
  AssignGuestToDishDialog({@required this.dish}) : assert(dish != null);

  final DishModel dish;

  @override
  State<StatefulWidget> createState() => _AssignGuestToDishDialog();
}

class _AssignGuestToDishDialog extends State<AssignGuestToDishDialog> {
  final Map<GuestModel, bool> _selectedMap = <GuestModel, bool>{};
  BillStateNotifier billStateNotifier;
  BillModel bill;
  List<GuestModel> guests;

  @override
  void initState() {
    super.initState();

    billStateNotifier = context.read(billStateNotifierProvider);
    bill = context.read(billStateNotifierProvider.state);
    guests = bill.guests;

    for (final GuestModel guest in guests) {
      _selectedMap[guest] =
          widget.dish.guests != null && widget.dish.guests.contains(guest);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final BillModel bill = useProvider(billStateNotifierProvider.state);
    // final List<GuestModel> guests = bill.guests;

    return AlertDialog(
      title: Column(
        children: <Widget>[
          Text(widget.dish.name),
          const Text(
            'Which guest(s) shared this dish?',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ), // button 1
        ElevatedButton(
          onPressed: () {
            _assignGuestsToDish();
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
      content: guests.isEmpty
          ? const Center(
              child: Text('Please add a guest'),
            )
          : SizedBox(
              width: double.minPositive,
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10.0),
                itemCount:
                    guests.length, // guests == null || guests.isEmpty ? 1 :
                // guests.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  // if (index == 0) {
                  //   return ListTile(
                  //     key: UniqueKey(),
                  //     title: const Text('Split equally'),
                  //     leading: const CircleAvatar(
                  //       backgroundColor: Colors.black,
                  //     ),
                  //     onTap: () => assignGuestToDish(context, null),
                  //   );
                  // }
                  //
                  // index -= 1;
                  final GuestModel guest = guests[index];
                  return _buildGuestListTile(context, guest);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(height: 1.0),
              ),
            ),
    );
  }

  Widget _buildGuestListTile(BuildContext context, GuestModel guest) {
    return CheckboxListTile(
      key: ValueKey<String>(guest.uuid),
      title: Text(guest.name),
      secondary: CircleAvatar(
        backgroundColor: guest.color,
      ),
      activeColor: Colors.blue[800],
      // checkColor: Colors.red[100],
      controlAffinity: ListTileControlAffinity.leading,
      selected: _selectedMap[guest],
      value: _selectedMap[guest],
      onChanged: (bool selected) =>
          _selectGuest(guest: guest, selected: selected),
    );
  }

  void _selectGuest({GuestModel guest, bool selected}) {
    setState(() => _selectedMap[guest] = selected);
  }

  void _assignGuestsToDish() {
    // final BillStateNotifier billStateNotifier =
    //     context.read(billStateNotifierProvider);
    final List<GuestModel> guests = <GuestModel>[];

    _selectedMap.forEach((GuestModel guest, bool selected) {
      if (selected) {
        guests.add(guest);
      }
    });

    final DishModel newDish = DishModel(
        uuid: widget.dish.uuid,
        name: widget.dish.name,
        price: widget.dish.price,
        guests: guests);
    billStateNotifier.editDish(newDish);
  }
}
