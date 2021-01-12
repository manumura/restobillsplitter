import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/dish_model.dart';
import 'package:restobillsplitter/shared/side_drawer.dart';
import 'package:restobillsplitter/state/providers.dart';
import 'package:restobillsplitter/widgets/dish_list_tile.dart';

class DishListScreen extends HookWidget {
  static const String routeName = '/dish_list';

  @override
  Widget build(BuildContext context) {
    final BillModel bill = useProvider(billStateNotifierProvider.state);
    final List<DishModel> dishes = bill.dishes;

    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: const Text('Dishes'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        actions: <Widget>[
          _buildAddDishButton(context),
        ],
      ),
      body: dishes.isEmpty
          ? const Center(
              child: Text('Please add a dish first'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) {
                final DishModel dish = dishes[index];
                return DishListTile(
                    key: ValueKey<String>(dish.uuid), dish: dish);
              },
              itemCount: dishes.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                thickness: 2.0,
              ),
            ),
    );
  }

  Widget _buildAddDishButton(BuildContext context) {
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
      onPressed: () => _addDish(context),
    );
  }

  void _addDish(BuildContext context) {
    final BillStateNotifier billStateNotifier =
        context.read(billStateNotifierProvider);
    billStateNotifier.addDish();
  }
}
