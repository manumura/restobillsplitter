import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/dish_model.dart';
import 'package:restobillsplitter/pages/assign_dish_list_tile.dart';
import 'package:restobillsplitter/state/providers.dart';

class AssignScreen extends HookWidget {
  static const String routeName = '/assign';

  final Logger logger = getLogger();

  @override
  Widget build(BuildContext context) {
    final BillModel bill = useProvider(billStateNotifierProvider.state);
    final List<DishModel> dishes = bill.dishes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign guests to dishes'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: dishes.isEmpty
          ? const Center(
              child: Text('Please add a dish'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) {
                final DishModel dish = dishes[index];
                return AssignDishListTile(
                    key: ValueKey<String>(dish.uuid), dish: dish);
              },
              itemCount: dishes.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                height: 5.0,
              ),
            ),
    );
  }
}
