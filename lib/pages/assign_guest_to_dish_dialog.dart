import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/dish_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';
import 'package:restobillsplitter/state/providers.dart';

class AssignGuestToDishDialog extends HookWidget {
  AssignGuestToDishDialog({@required this.dish}) : assert(dish != null);

  final DishModel dish;

  @override
  Widget build(BuildContext context) {
    final BillModel bill = useProvider(billStateNotifierProvider.state);
    final List<GuestModel> guests = bill.guests;

    return AlertDialog(
      title: Text('Choose a guest to assign to this dish : ${dish.name}'),
      content: guests.isEmpty
          ? const Center(
              child: Text('Please add a guest'),
            )
          : SizedBox(
              width: double.minPositive,
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10.0),
                itemBuilder: (BuildContext context, int index) {
                  final GuestModel guest = guests[index];
                  return Text('${guest.name}');
                },
                itemCount: guests.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
    );
  }
}
