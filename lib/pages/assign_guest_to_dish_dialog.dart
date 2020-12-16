import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';
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
      title: Column(
        children: [
          Text(dish.name),
          const Text('Which guest ordered this dish?'),
        ],
      ),
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
                    guests == null || guests.isEmpty ? 1 : guests.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return ListTile(
                      key: UniqueKey(),
                      title: const Text('Split equally'),
                      leading: const CircleAvatar(
                        backgroundColor: Colors.black,
                      ),
                      onTap: () => assignGuestToDish(context, null),
                    );
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
    return ListTile(
      key: ValueKey<String>(guest.uuid),
      title: Text(guest.name),
      leading: CircleAvatar(
        backgroundColor: guest.color,
      ),
      onTap: () => assignGuestToDish(context, guest),
    );
  }

  void assignGuestToDish(BuildContext context, GuestModel guest) {
    final BillStateNotifier billStateNotifier =
        context.read(billStateNotifierProvider);
    final DishModel newDish = DishModel(
        uuid: dish.uuid, name: dish.name, price: dish.price, guest: guest);
    billStateNotifier.editDish(newDish);
    Navigator.of(context).pop();
  }
}
