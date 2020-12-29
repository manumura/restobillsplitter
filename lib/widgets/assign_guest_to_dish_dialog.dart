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
  bool _isSelectEveryoneChecked = true;
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
      final bool isGuestSelected =
          widget.dish.guests != null && widget.dish.guests.contains(guest);
      _selectedMap[guest] = isGuestSelected;
      _isSelectEveryoneChecked = _isSelectEveryoneChecked && isGuestSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(20),
      title: Column(
        children: <Widget>[
          Text(
            widget.dish.name,
            style: const TextStyle(
              // fontSize: 16,
              color: Colors.black,
            ),
          ),
          const Text(
            'Which guest(s) shared this dish?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
      actions: <Widget>[
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
              child: Text('Please add a guest first'),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10.0),
                // itemCount: guests.length,
                // itemBuilder: (BuildContext context, int index) {
                //   final GuestModel guest = guests[index];
                //   return _buildGuestListTile(context, guest);
                // },
                itemCount:
                    guests == null || guests.isEmpty ? 1 : guests.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return _buildAllListTile(context);
                  }

                  index -= 1;
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

  Widget _buildAllListTile(BuildContext context) {
    return CheckboxListTile(
      key: UniqueKey(),
      title: const Text('Select everyone'),
      secondary: const CircleAvatar(
        backgroundColor: Colors.black,
      ),
      activeColor: Colors.blue[800],
      // checkColor: Colors.red[100],
      controlAffinity: ListTileControlAffinity.leading,
      selected: _isSelectEveryoneChecked,
      value: _isSelectEveryoneChecked,
      onChanged: (bool selected) => _selectAll(selected: selected),
    );
  }

  void _selectGuest({GuestModel guest, bool selected}) {
    setState(() => _selectedMap[guest] = selected);
  }

  void _selectAll({bool selected}) {
    setState(() {
      _isSelectEveryoneChecked = selected;
      for (final MapEntry<GuestModel, bool> selectedMapEntry
          in _selectedMap.entries) {
        _selectedMap[selectedMapEntry.key] = selected;
      }
    });
  }

  void _assignGuestsToDish() {
    final List<GuestModel> guests = <GuestModel>[];

    _selectedMap.forEach((GuestModel guest, bool selected) {
      if (selected) {
        guests.add(guest);
      }
    });

    billStateNotifier.assignGuestsToDish(widget.dish, guests);
  }
}
